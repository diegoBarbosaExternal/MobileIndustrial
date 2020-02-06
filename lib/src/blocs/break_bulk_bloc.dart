import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sugar/src/bloc_validators/super_emb_receb_validator.dart';
import 'package:sugar/src/blocs/login_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/turno_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/caminhoes_vagoes.dart';
import 'package:sugar/src/models/embarque.dart';
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/recebimento.dart';
import 'package:sugar/src/models/sincronizar_breakbulk.dart';
import 'package:sugar/src/models/time_logs.dart';

class BreakBulkBloc extends BlocBase with SupEmbRecebStateValidator {
  final LoginBloc blocLogin =
  BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();

//  Formulario formulario = Formulario.padrao();
  final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
  final blocTipoUsina =
  BlocProvider.tag('sugarGlobal').getBloc<TipoUsinaBloc>();
  final blocTurno = BlocProvider.tag('sugarGlobal').getBloc<DropDowBlocTurno>();
  SugarBloc sugarBloc = SugarBloc();

  List<CaminhoesVagoes> listCaminhoesVagoes = [];
  List<TimeLogs> listTimeLogs = [];
  List<Embarque> listEmbarques = [];
  List<Recebimento> listRecebimentos = [];

  final keyFormSuperEmbRece = GlobalKey<FormState>();
  final keyFormCaminhoesVagoes = GlobalKey<FormState>();
  final keyFormGlobalKeyTimeLogs = GlobalKey<FormState>();
  final keyFormEmbarque = GlobalKey<FormState>();
  final keyFormRecebimento = GlobalKey<FormState>();

  //COMBOS
  final keyComboProdutoSuperEmbRec = GlobalKey<FormState>();
  final keyComboTipoUsina = GlobalKey<FormState>();
  final keyComboTurno = GlobalKey<FormState>();
  final keyComboUsinaRecebimento = GlobalKey<FormState>();

  //List<DadosBreakBulk> list = [];
  List<BreakBulk> listBreakBulks = [];

  // ASSINATURA DIGITAL
  //---------------------------------------------------------------------------------------------------
  final _isSaveController = BehaviorSubject<bool>();

  Stream<bool> get outIsSave => _isSaveController.stream;

  //---------------------------------------------------------------------------------------------------

  // INICIAR LISTAR BREAKBULK
  //---------------------------------------------------------------------------------------------------

  final _listBreakBulkCaminhoesVagoesController =
  BehaviorSubject<List<CaminhoesVagoes>>();

  Stream<List<CaminhoesVagoes>> get outListBreakBulkCaminhoesVagoes =>
      _listBreakBulkCaminhoesVagoesController.stream;

  Sink<List<CaminhoesVagoes>> get sinkListBreakBulkCaminhoesVagoes =>
      _listBreakBulkCaminhoesVagoesController.sink;

  List<CaminhoesVagoes> get getListCaminhoesVagoes =>
      _listBreakBulkCaminhoesVagoesController.stream.value;

  final _listInicialTimeLogsController = BehaviorSubject<List<TimeLogs>>();

  Stream<List<TimeLogs>> get outListInicialTimeLogs =>
      _listInicialTimeLogsController.stream;

  Sink<List<TimeLogs>> get sinkListInicialTimeLogs =>
      _listInicialTimeLogsController.sink;

  List<TimeLogs> get getListTimeLogs =>
      _listInicialTimeLogsController.stream.value;

  final _listInicialEmbarqueController = BehaviorSubject<List<Embarque>>();

  Stream<List<Embarque>> get outListInicialEmbarque =>
      _listInicialEmbarqueController.stream;

  Sink<List<Embarque>> get sinkListInicialEmbarque =>
      _listInicialEmbarqueController.sink;

  List<Embarque> get getListEmbarque =>
      _listInicialEmbarqueController.stream.value;

  final _listInicialRecebimentoController =
  BehaviorSubject<List<Recebimento>>();

  Stream<List<Recebimento>> get outListInicialRecebimento =>
      _listInicialRecebimentoController.stream;

  Sink<List<Recebimento>> get sinkListInicialRecebimento =>
      _listInicialRecebimentoController.sink;

  List<Recebimento> get getListRecebimento =>
      _listInicialRecebimentoController.stream.value;

//---------------------------------------------------------------------------------------------------

  //SUPERVISAO / EMBARQUE / RECEBIMENTO CONTROLLERS
  //---------------------------------------------------------------------------------------------------
  final _produtoController = BehaviorSubject<String>();

  Stream<String> get outProduto =>
      _produtoController.stream.transform(validateDropDownProduto);

  final _ordemServicoController = BehaviorSubject<String>();

  Stream<String> get outOrdemServico =>
      _ordemServicoController.stream.transform(validateVazio);

  Sink get sinkOrdemServico => _ordemServicoController.sink;

  final _clientePrincipalController = BehaviorSubject<String>();

  Stream<String> get outClientePrincipal =>
      _clientePrincipalController.stream.transform(validateVazio);

  final _localTerminalController = BehaviorSubject<String>();

  Stream<String> get outLocalTerminal =>
      _localTerminalController.stream.transform(validateVazio);

  final _navioController = BehaviorSubject<String>();

  Stream<String> get outNavio => _navioController.stream;

  final _origemController = BehaviorSubject<String>();

  Stream<String> get outOrigem => _origemController.stream;

  final _validateSuperEmbRecebController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateSuperEmbReceb =>
      _validateSuperEmbRecebController.stream;

  final _keyFormSuperEmbRecebController = BehaviorSubject<Key>();

  Stream<Key> get outKeyFormSuperEmbRece =>
      _keyFormSuperEmbRecebController.stream;

  // ON CHANGE
//----------------
  Function(String) get changeOS => _ordemServicoController.sink.add;

  Function(String) get changeClientePrincipal =>
      _clientePrincipalController.sink.add;

  Function(String) get changeOLocalTerminal =>
      _localTerminalController.sink.add;

  Function(String) get changeNavio => _navioController.sink.add;

  Function(String) get changeOrigem => _origemController.sink.add;

  Sink<bool> get inAutoValidateSuperEmbReceb =>
      _validateSuperEmbRecebController.sink;

  Sink<Key> get inkeyFormSuperEmbReceb => _keyFormSuperEmbRecebController.sink;

  Sink<String> get sinkClientePrincipal => _clientePrincipalController.sink;

  Sink<String> get sinkLocalTerminal => _localTerminalController.sink;

  Sink<String> get sinkNavio => _navioController.sink;

  Sink<String> get sinkOrigem => _origemController.sink;

  //---------------------------------------------------------------------------------------------------

  //CAMINHOES VAGOES CONTROLLERS
  //---------------------------------------------------------------------------------------------------

  final _resumoController = BehaviorSubject<String>();

  Stream<String> get outResumo =>
      _resumoController.stream.transform(validateVazio);

  final _caminhoesVagoesController = BehaviorSubject<String>();

  Stream<String> get outCaminhoesVagoes =>
      _caminhoesVagoesController.stream.transform(validateVazio);

  final _placaController = BehaviorSubject<String>();

  Stream<String> get outPlaca =>
      _placaController.stream.transform(validateVazio);

  final _pesoNotaController = BehaviorSubject<String>();

  Stream<String> get outPesoNota =>
      _pesoNotaController.stream.transform(validateVazio);

  final _quantidadeSacasRecebController = BehaviorSubject<String>();

  Stream<String> get outQuantidadeSacasReceb =>
      _quantidadeSacasRecebController.stream.transform(validateVazio);

  final _quantidadeController = BehaviorSubject<String>();

  Stream<String> get outQuantidade =>
      _quantidadeController.stream.transform(validateVazio);

  final _notaFiscalController = BehaviorSubject<String>();

  Stream<String> get outNotaFiscal =>
      _notaFiscalController.stream.transform(validateVazio);

  final _observacaoController = BehaviorSubject<String>();

  Stream<String> get outObservacao => _observacaoController.stream;

  final _faltasController = BehaviorSubject<String>();

  Stream<String> get outFaltas => _faltasController.stream;

  final _sobrasController = BehaviorSubject<String>();

  Stream<String> get outSobras =>
      _sobrasController.stream.transform(validateVazio);

  final _totalUnidadesController = BehaviorSubject<String>();

  Stream<String> get outTotalUnidades =>
      _totalUnidadesController.stream.transform(validateVazio);

  final _molhadasBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outMolhadas => _molhadasBloc.stream;

  Sink<bool> get sinkMolhadas => _molhadasBloc.sink;

  final _sujasBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outSujas => _sujasBloc.stream;

  Sink get sinkSujas => _sujasBloc.sink;

  final _rasgadasBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outRasgadas => _rasgadasBloc.stream;

  Sink get sinkRasgadas => _rasgadasBloc.sink;

  final _empedradasBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outEmpedradas => _empedradasBloc.stream;

  Sink get sinkEmpedradas => _empedradasBloc.sink;

  final _validateCaminhoesVagoesController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateCaminhoesVagoes =>
      _validateCaminhoesVagoesController.stream;

  // ON CHANGE
//----------------

  Function(String) get changeCaminhoesVagoes =>
      _caminhoesVagoesController.sink.add;

  Function(String) get changePlaca => _placaController.sink.add;

  Function(String) get changePesoNota => _pesoNotaController.sink.add;

  Function(String) get changeNotaFiscal => _notaFiscalController.sink.add;

  Function(String) get changeQuantidadeSacasReceb => _quantidadeSacasController.sink.add;

  Function(String) get changeQuantidade => _quantidadeController.sink.add;

  Function(String) get changeFaltas => _faltasController.sink.add;

  Function(String) get changeSobras => _sobrasController.sink.add;

  Function(String) get changeTotalUnidades => _totalUnidadesController.sink.add;

  Function(String) get changeObservacao => _observacaoController.sink.add;

  Function(String) get changeResumo => _resumoController.sink.add;

  Sink<bool> get inAutoValidateCaminhoesVagoes =>
      _validateCaminhoesVagoesController.sink;

  //---------------------------------------------------------------------------------------------------
  // TIMELOGS CONTROLLERS
  //---------------------------------------------------------------------------------------------------

  final _selecionarDataInicioController = BehaviorSubject<DateTime>();

  Stream<String> get outSelecionarInicioData =>
      _selecionarDataInicioController.stream.transform(validateDateTime);

  final _selecionarDataTerminoController = BehaviorSubject<DateTime>();

  Stream<String> get outSelecionarTerminoData =>
      _selecionarDataTerminoController.stream.transform(validateDateTime);

  final _ocorrenciaController = BehaviorSubject<String>();

  Stream<String> get outOcorrencia => _ocorrenciaController.stream;

  final _validateTimeLogsController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateTimeLogs =>
      _validateTimeLogsController.stream;

  // ON CHANGE
//----------------

  Function(String) get changeOcorrencia => _ocorrenciaController.sink.add;

  Function(DateTime) get changeSelecionarDataInicio =>
      _selecionarDataInicioController.sink.add;

  Function(DateTime) get changeSelecionarTerminoData =>
      _selecionarDataTerminoController.sink.add;

  Sink<bool> get inAutoValidateTimeLogs => _validateTimeLogsController.sink;

  //---------------------------------------------------------------------------------------------------

  // EMBARQUE CONTROLLERS
  //---------------------------------------------------------------------------------------------------
  final _quantidadeTotalPesoController = BehaviorSubject<String>();

  Stream<String> get outQuantidadeTotalPeso =>
      _quantidadeTotalPesoController.stream.transform(validateVazio);

  Sink<String> get sinkQuantidadeTotalPeso =>
      _quantidadeTotalPesoController.sink;

  final _portoController = BehaviorSubject<String>();

  Stream<String> get outPorto =>
      _portoController.stream.transform(validateVazio);

  final _destinoController = BehaviorSubject<String>();

  Stream<String> get outDestino =>
      _destinoController.stream.transform(validateVazio);

  final _dataInicioController = BehaviorSubject<DateTime>();

  Stream<String> get outDataInicio =>
      _dataInicioController.stream.transform(validateDateTime);

  final _dataTerminoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataTermino =>
      _dataTerminoController.stream.transform(validateDateTime);

  final _inspetorasController = BehaviorSubject<String>();

  Stream<String> get outInspetoras =>
      _inspetorasController.stream.transform(validateVazio);

  final _quantidadeSacasController = BehaviorSubject<String>();

  Stream<String> get outQuantidadeSacas =>
      _quantidadeSacasController.stream.transform(validateVazio);

  Sink get sinkQuantidadeDeSacas => _quantidadeSacasController.sink;

  final _pesoMedioController = BehaviorSubject<String>();

  Stream<String> get outPesoMedio =>
      _pesoMedioController.stream.transform(validateVazio);

  Sink<String> get sinkPesoMedio =>
      _pesoMedioController.sink;

  final _validateEmbarqueController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateEmbarque =>
      _validateEmbarqueController.stream;

  // ON CHANGE
//----------------

  Function(String) get changePorto => _portoController.sink.add;

  Function(String) get changeDestino => _destinoController.sink.add;

  Function(DateTime) get changeDataInicio => _dataInicioController.sink.add;

  Function(DateTime) get changeDataTermino => _dataTerminoController.sink.add;

  Function(String) get changeInspetoras => _inspetorasController.sink.add;

  Sink<bool> get inAutoValidateEmbarque => _validateEmbarqueController.sink;

  //---------------------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------------

  // RECEBIMENTOS CONTROLLERS

  final _analiseDeProdutoController = BehaviorSubject<String>();

  Stream<String> get outAnaliseDeProduto => _analiseDeProdutoController.stream;

  final _resultadoController = BehaviorSubject<String>();

  Stream<String> get outResultado => _resultadoController.stream;

  final _numeroCaminhoesCompostaController = BehaviorSubject<String>();

  Stream<String> get outNumeroCaminhoesComposta =>
      _numeroCaminhoesCompostaController.stream.transform(validateVazio);

  final _validateRecebimentoController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateRecebimento =>
      _validateRecebimentoController.stream;

  // ON CHANGE
//----------------
  Function(String) get changeAnaliseDeProduto =>
      _analiseDeProdutoController.sink.add;

  Sink<String> get inAnaliseProdutoBloc => _analiseDeProdutoController.sink;

  Function(String) get changeResultado => _resultadoController.sink.add;

  Function(String) get changeNumeroCaminhoesComposta =>
      _numeroCaminhoesCompostaController.sink.add;

  Sink<bool> get inAutoValidateRecebimento =>
      _validateRecebimentoController.sink;

  //ASSINATURA DIGITAL

  final _assinaturaInspetorBloc = BehaviorSubject<String>();

  Stream<String> get outAssinaturaInspetorBloc =>
      _assinaturaInspetorBloc.stream;

  Sink<String> get inAssinaturaInspetorBloc => _assinaturaInspetorBloc.sink;

  final _assinaturaTerminalBloc = BehaviorSubject<String>();

  Stream<String> get outAssinaturaTerminalBloc =>
      _assinaturaTerminalBloc.stream;

  Sink<String> get inAssinaturaTerminalBloc => _assinaturaTerminalBloc.sink;

  final _validaAssinaturaInspetorBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outValidaAssinaturaInspetorBloc =>
      _validaAssinaturaInspetorBloc.stream;

  Sink<bool> get inValidaAssinaturaInspetorBloc =>
      _validaAssinaturaInspetorBloc.sink;

  final _validaAssinaturaTerminalBloc = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outValidaAssinaturaTerminalBloc =>
      _validaAssinaturaTerminalBloc.stream;

  Sink<bool> get inValidaAssinaturaTerminalrBloc =>
      _validaAssinaturaTerminalBloc.sink;

  String get getAssInspetorSGS => _assinaturaInspetorBloc.stream.value;

  String get getAssTerminal => _assinaturaTerminalBloc.stream.value;

  //------------------------
  // VALIDA ASSINATURAS
  //------------------------

  bool validarAssinaturaInspetor() {
    if (getAssInspetorSGS == null) {
      inValidaAssinaturaInspetorBloc.add(true);
      return false;
    } else {
      inValidaAssinaturaInspetorBloc.add(false);
      return true;
    }
  }

  bool validarAssinaturaTerminal() {
    if (getAssTerminal == null) {
      inValidaAssinaturaTerminalrBloc.add(true);
      return false;
    } else {
      inValidaAssinaturaTerminalrBloc.add(false);
      return true;
    }
  }

  //---------------------------------------------------------------------------------------------------

  Future<bool> salvarSuperEmbReceb(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          form.dadosbreakbulk.produto = blocProduto.valueProdutSuperEmbReceb;
          form.dadosbreakbulk.ordemDeServico = _ordemServicoController.value;
          form.dadosbreakbulk.clientePrincipal =
              _clientePrincipalController.value;
          form.dadosbreakbulk.localTerminal = _localTerminalController.value;
          form.dadosbreakbulk.navio = _navioController.value;
          form.dadosbreakbulk.origem = _origemController.value;
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarCaminhoesVagoes(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadosbreakbulk.caminhoesVagoesRegistrados == null ||
              form.dadosbreakbulk.caminhoesVagoesRegistrados.isEmpty) {
            form.dadosbreakbulk.caminhoesVagoesRegistrados = [
              adicionarCaminhoesVagoes()
            ];
            form.dadosbreakbulk.resumo = _resumoController.value;
          } else {
            form.dadosbreakbulk.caminhoesVagoesRegistrados
                .add(adicionarCaminhoesVagoes());
            form.dadosbreakbulk.resumo = _resumoController.value;
          }
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      formulario.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == uuid) {
          sinkListBreakBulkCaminhoesVagoes
              .add(dadosBreakBulk.dadosbreakbulk.caminhoesVagoesRegistrados);
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarTimeLogs(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();

      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadosbreakbulk.timeLogs == null ||
              form.dadosbreakbulk.timeLogs.isEmpty) {
            form.dadosbreakbulk.timeLogs = [adicionarTimeLogs()];
          } else {
            form.dadosbreakbulk.timeLogs.add(adicionarTimeLogs());
          }
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      formulario.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == uuid) {
          sinkListInicialTimeLogs.add(dadosBreakBulk.dadosbreakbulk.timeLogs);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarEmbarque(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();

      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadosbreakbulk.embarquesRegistrados == null ||
              form.dadosbreakbulk.embarquesRegistrados.isEmpty) {
            form.dadosbreakbulk.embarquesRegistrados = [adicionarEmbarques()];
          } else {
            form.dadosbreakbulk.embarquesRegistrados.add(adicionarEmbarques());
          }
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      formulario.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == uuid) {
          sinkListInicialEmbarque
              .add(dadosBreakBulk.dadosbreakbulk.embarquesRegistrados);
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarRecebimento(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadosbreakbulk.recebimentosRegistrados == null ||
              form.dadosbreakbulk.recebimentosRegistrados.isEmpty) {
            form.dadosbreakbulk.recebimentosRegistrados = [
              adicionarRecebimentos()
            ];
          } else {
            form.dadosbreakbulk.recebimentosRegistrados
                .add(adicionarRecebimentos());
          }
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      formulario.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == uuid) {
          sinkListInicialEmbarque
              .add(dadosBreakBulk.dadosbreakbulk.embarquesRegistrados);
        }
      });

      formulario.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == uuid) {
          sinkListInicialRecebimento
              .add(dadosBreakBulk.dadosbreakbulk.recebimentosRegistrados);
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarAssinaturaDigital(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          form.dadosbreakbulk.inspetorSgs = _assinaturaInspetorBloc.value;
          form.dadosbreakbulk.terminal = _assinaturaTerminalBloc.value;
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sincronizarBreakBulk(uuid) async {
    _isSaveController.add(true);
    final bloc = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      Map<String, dynamic> sincronizarBreakbulk;

      formulario.breakBulk.forEach((form) {
        if (form.uuid == uuid) {
          form.status = 'SINCRONIZADO';
          sincronizarBreakbulk = SincronizarBreakbulk(
              idUsuario: formulario.idUsuario,
              login: formulario.login,
              status: 1,
              tipoFormulario: bloc.valueIdFormAtualSincronizado,
              breakBulk: form)
              .toJson();
        }
      });

      bool sincronizado = await sugarBloc.sincronizarService(status: 1,
          tipoFormulario: bloc.valueIdFormAtualSincronizado,
          formulario: sincronizarBreakbulk, tipo: 1,);

      if (sincronizado) {
        formulario.breakBulk.removeWhere((breakbulk) => breakbulk.uuid == uuid);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);

        final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

        blocSugar.sinkLisInicial.add(formulario);
        _isSaveController.add(false);
        return true;
      } else {
        _isSaveController.add(false);
        return false;
      }
    } catch (e) {
      _isSaveController.add(false);
      return false;
    }
  }

  CaminhoesVagoes adicionarCaminhoesVagoes() {
    CaminhoesVagoes caminhoesVagoes = CaminhoesVagoes.padrao();

    caminhoesVagoes.caminhoesVagoes = _caminhoesVagoesController.value;
    caminhoesVagoes.notaFiscal = _notaFiscalController.value;
    caminhoesVagoes.quantidade = _quantidadeController.value;

    caminhoesVagoes.molhada = _molhadasBloc.value;
    caminhoesVagoes.rasgada = _rasgadasBloc.value;
    caminhoesVagoes.suja = _sujasBloc.value;
    caminhoesVagoes.empedrada = _empedradasBloc.value;

    caminhoesVagoes.falta =
    (_faltasController.value != null && _faltasController.value.isNotEmpty)
        ? int.parse(_faltasController.value)
        : 0;
    caminhoesVagoes.sobra =
    (_sobrasController.value != null && _sobrasController.value.isNotEmpty)
        ? int.parse(_sobrasController.value)
        : 0;
    caminhoesVagoes.totalUnidades = (_totalUnidadesController.value != null &&
        _totalUnidadesController.value.isNotEmpty)
        ? int.parse(_totalUnidadesController.value)
        : 0;

    caminhoesVagoes.observacao = _observacaoController.value;

    return caminhoesVagoes;
  }

  TimeLogs adicionarTimeLogs() {
    TimeLogs timeLogs = TimeLogs.padrao();

    timeLogs.dataInicial = _selecionarDataInicioController.value.toString();
    timeLogs.dataTermino = _selecionarDataTerminoController.value.toString();
    timeLogs.ocorrencia = _ocorrenciaController.value;

    return timeLogs;
  }

  Embarque adicionarEmbarques() {
    Embarque embarque = Embarque.padrao();

    embarque.quantidadeTotalPeso =
    (_quantidadeTotalPesoController.value != null &&
        _quantidadeTotalPesoController.value.isNotEmpty)
        ? double.parse(_quantidadeTotalPesoController.value)
        : 0.0;
    embarque.porto = _portoController.value;
    embarque.destino = _destinoController.value;
    embarque.dataInicioPorto = _dataInicioController.value.toString();
    embarque.dataTerminoPorto = _dataTerminoController.value.toString();
    embarque.inspetora = _inspetorasController.value;
    embarque.quantidadeSaca = _quantidadeSacasController.value;
    embarque.pesoMedioSaca = double.parse(_pesoMedioController.value);

    return embarque;
  }

  Recebimento adicionarRecebimentos() {
    Recebimento recebimento = Recebimento.padrao();

    recebimento.tipoUsina = blocTipoUsina.valueTipoUsina;
    recebimento.usina = blocUsina.valueRecebimento;
    recebimento.turno = blocTurno.valueTurno;
    if(_analiseDeProdutoController.value != null){
      recebimento.analiseProduto = _analiseDeProdutoController.value;
    }
    if(_resultadoController.value != null){
      recebimento.resultado = _resultadoController.value;
    }

    recebimento.numeroCaminhoesComposta =
    (_numeroCaminhoesCompostaController.value != null &&
        _numeroCaminhoesCompostaController.value.isNotEmpty)
        ? int.parse(_numeroCaminhoesCompostaController.value)
        : 0;

    return recebimento;
  }

  excluirTimeLogs({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == uuid) {
        dadosBreakBulk.dadosbreakbulk.timeLogs.removeAt(indice);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListInicialTimeLogs.add(dadosBreakBulk.dadosbreakbulk.timeLogs);
      }
    });
  }
  excluirCaminhoesVagoes({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == uuid) {
        dadosBreakBulk.dadosbreakbulk.caminhoesVagoesRegistrados.removeAt(indice);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListBreakBulkCaminhoesVagoes.add(dadosBreakBulk.dadosbreakbulk.caminhoesVagoesRegistrados);
      }
    });
  }

  excluirEmbarque({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == uuid) {
        dadosBreakBulk.dadosbreakbulk.embarquesRegistrados.removeAt(indice);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListInicialEmbarque.add(dadosBreakBulk.dadosbreakbulk.embarquesRegistrados);
      }
    });
  }

  excluirRecebimento({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == uuid) {
        dadosBreakBulk.dadosbreakbulk.recebimentosRegistrados.removeAt(indice);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListInicialRecebimento.add(dadosBreakBulk.dadosbreakbulk.recebimentosRegistrados);
      }
    });
  }

  @override
  void dispose() {
    _isSaveController.close();

    _listBreakBulkCaminhoesVagoesController.close();
    _listInicialTimeLogsController.close();
    _listInicialEmbarqueController.close();
    _listInicialRecebimentoController.close();
    _produtoController.close();
    _ordemServicoController.close();
    _clientePrincipalController.close();
    _localTerminalController.close();
    _navioController.close();
    _origemController.close();
    _validateSuperEmbRecebController.close();
    _molhadasBloc.close();
    _sujasBloc.close();
    _rasgadasBloc.close();
    _empedradasBloc.close();
    _assinaturaInspetorBloc.close();
    _assinaturaTerminalBloc.close();
    _resumoController.close();
    _caminhoesVagoesController.close();
    _quantidadeController.close();
    _notaFiscalController.close();
    _observacaoController.close();
    _faltasController.close();
    _sobrasController.close();
    _totalUnidadesController.close();
    _selecionarDataInicioController.close();
    _selecionarDataTerminoController.close();
    _ocorrenciaController.close();
    _quantidadeTotalPesoController.close();
    _portoController.close();
    _destinoController.close();
    _dataInicioController.close();
    _dataTerminoController.close();
    _inspetorasController.close();
    _quantidadeSacasController.close();
    _analiseDeProdutoController.close();
    _resultadoController.close();
    _numeroCaminhoesCompostaController.close();
    _pesoMedioController.close();
    _validateSuperEmbRecebController.close();
    _keyFormSuperEmbRecebController.close();
    _validateTimeLogsController.close();
    _validateCaminhoesVagoesController.close();
    _validateEmbarqueController.close();
    _validateRecebimentoController.close();
    _validaAssinaturaInspetorBloc.close();
    _validaAssinaturaTerminalBloc.close();

    super.dispose();
  }
}
