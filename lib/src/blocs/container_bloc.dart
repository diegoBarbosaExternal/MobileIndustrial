import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as key;
import 'package:rxdart/rxdart.dart';
import 'package:sugar/src/bloc_validators/super_emb_receb_validator.dart';
import 'package:sugar/src/blocs/numero_container_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/container.dart';
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/inf_container.dart';
import 'package:sugar/src/models/quebra_nota.dart';
import 'package:sugar/src/models/quebra_notas_fiscais.dart';
import 'package:sugar/src/models/sincronizar_container.dart';
import 'package:sugar/src/models/time_logs.dart';
import 'package:intl/intl.dart';
import 'login_bloc.dart';


class ContainerBloc extends BlocBase with SupEmbRecebStateValidator {
  final LoginBloc blocLogin =
      BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();

  Formulario formulario = Formulario.padrao();
  List<Container> listContainers = [];
  List<InformacaoContainer> listInformacoesContainer = [];
  List<TimeLogs> listTimeLogs = [];
  List<QuebraNotasFiscais> listQuebraDeNotas = [];
  String pesoLiquido;
  SugarBloc sugarBloc = SugarBloc();

  final keyFormGlobalKeyTimeLogs = key.GlobalKey<key.FormState>();

  final keyFormInspEstufDesova = key.GlobalKey<key.FormState>();
  final keyFormInspEstufDesovaResumo = key.GlobalKey<key.FormState>();
  final keyFormInspEstufInformacaoCon = key.GlobalKey<key.FormState>();
  final keyFormControleQtd = key.GlobalKey<key.FormState>();
  final keyFormSupervisaoPeso = key.GlobalKey<key.FormState>();
  final keyFormQuebraNota = key.GlobalKey<key.FormState>();

  //COMBOS
  final keyComboProdutoInspEstuDesova = key.GlobalKey<key.FormState>();
  final keyComboTipoAcucarQuebraDeNota = key.GlobalKey<key.FormState>();
  final keyComboUsinaSupervisaoPeso = key.GlobalKey<key.FormState>();
  final keyComboNumeroContainer = key.GlobalKey<key.FormState>();
  final keyComboUsinaQuebraNota = key.GlobalKey<key.FormState>();

  // ASSINATURA DIGITAL
  //---------------------------------------------------------------------------------------------------
  final _isSaveController = BehaviorSubject<bool>();

  Stream<bool> get outIsSave => _isSaveController.stream;

  //---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------
// INICIAR LISTAR CONTAINER
  //---------------------------------------------------------------------------------------------------

  final _listInicialInspecaoEstufagemDesovaController =
      BehaviorSubject<List<InformacaoContainer>>();

  Stream<List<InformacaoContainer>> get outListInicialInspecaoEstufagemDesova =>
      _listInicialInspecaoEstufagemDesovaController.stream;

  Sink<List<InformacaoContainer>> get sinkListInicialInspecaoEstufagemDesova =>
      _listInicialInspecaoEstufagemDesovaController.sink;

  List<InformacaoContainer> get listInspEstuDesoInfo =>
      _listInicialInspecaoEstufagemDesovaController.stream.value;

  final _listInicialTimeLogsController = BehaviorSubject<List<TimeLogs>>();

  Stream<List<TimeLogs>> get outListInicialTimeLogs =>
      _listInicialTimeLogsController.stream;

  Sink<List<TimeLogs>> get sinkListInicialTimeLogs =>
      _listInicialTimeLogsController.sink;

  final _listInicialQuebraDeNotaController =
      BehaviorSubject<List<QuebraNotasFiscais>>();

  Stream<List<QuebraNotasFiscais>> get outListInicialQuebraDeNota =>
      _listInicialQuebraDeNotaController.stream;

  Sink<List<QuebraNotasFiscais>> get sinkListInicialQuebraDeNota =>
      _listInicialQuebraDeNotaController.sink;

  List<QuebraNotasFiscais> get listInicialQuebraDeNota =>
      _listInicialQuebraDeNotaController.stream.value;

  bool verificarContainerQuebraNota(nomeContainer) {
    bool existeContainer = false;
    listInicialQuebraDeNota?.forEach((quebraNota) {
      if (quebraNota.container == nomeContainer) {
        existeContainer = true;
      }
    });
    return existeContainer;
  }

//---------------------------------------------------------------------------------------------------
  // INSPEÇÃO ESTUFAGEM DESOVA CONTROLLERS
//---------------------------------------------------------------------------------------------------

  final _listQuebraDeNotaController = BehaviorSubject<Formulario>();

  Stream<Formulario> get outListQuebraDeNota =>
      _listQuebraDeNotaController.stream;

  Sink get sinkListQuebraDeNota => _listQuebraDeNotaController.sink;

  final _listInspEstufDesovaController = BehaviorSubject<Formulario>();

  Stream<Formulario> get outListInspEstufDesova =>
      _listInspEstufDesovaController.stream;

  Sink get sinkListInspEstufDesova => _listInspEstufDesovaController.sink;

//---------------------------------------------------------------------------------------------------
  final _inspecaoController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outInspecao => _inspecaoController.stream;

  Sink<bool> get sinkInspecao => _inspecaoController.sink;

  final _estufagemController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outEstufagem => _estufagemController.stream;

  Sink<bool> get sinkEstufagem => _estufagemController.sink;

  final _desovaController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outDesova => _desovaController.stream;

  Sink<bool> get sinkDesova => _desovaController.sink;

  //-------

  final _inspetorController = BehaviorSubject<String>();

  Stream<String> get outInspetor =>
      _inspetorController.stream.transform(validateVazio);

  final _matriculaController = BehaviorSubject<String>();

  Stream<String> get outMatricula =>
      _matriculaController.stream.transform(validateVazio);

  final _osController = BehaviorSubject<String>();

  Stream<String> get outOrdemDeServico =>
      _osController.stream.transform(validateVazio);

  final _clientePrincipalController = BehaviorSubject<String>();

  Stream<String> get outClientePrincipal =>
      _clientePrincipalController.stream.transform(validateVazio);

  final _localTerminalController = BehaviorSubject<String>();

  Stream<String> get outLocalTerminal =>
      _localTerminalController.stream.transform(validateVazio);
  // 1536 datahora
  //final _dataHoraInicioInspecaoController = BehaviourSubject
  final _dataHoraInicioInspecaoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataHoraInicioInspecaoController =>
      _dataHoraInicioInspecaoController.stream.transform(validateDateTime);

  Sink<DateTime> get sinkDataHoraInicioInspecao => _dataHoraInicioInspecaoController.sink;


  final _dataHoraFimInspecaoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataHoraFimInspecaoController =>
      _dataHoraFimInspecaoController.stream.transform(validateDateTime);

  final _dataHoraInicioEstuDesoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataHoraInicioEstuDesoController =>
      _dataHoraInicioEstuDesoController.stream.transform(validateDateTime);

  final _dataHoraFimEstuDesoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataHoraFimEstuDesoController =>
      _dataHoraFimEstuDesoController.stream.transform(validateDateTime);

  final _bookingController = BehaviorSubject<String>();

  Stream<String> get outBooking =>
      _bookingController.stream.transform(validateVazio);

  final _navioController = BehaviorSubject<String>();

  Stream<String> get outNavio => _navioController.stream;

  final _identificacaoEquipamentoController = BehaviorSubject<String>();

  Stream<String> get outIdentificacaoEquipamento =>
      _identificacaoEquipamentoController.stream.transform(validateVazio);

  final _numeroCertificadoController = BehaviorSubject<String>();

  Stream<String> get outNumeroCertificado =>
      _numeroCertificadoController.stream.transform(validateVazio);

  final _dataVerificacaoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataVerificacao =>
      _dataVerificacaoController.stream.transform(validateDateTime);

  final _validateTipoInspEstuDesoController = BehaviorSubject<bool>();

  Stream<bool> get outValidateTipoInspEstuDeso =>
      _validateTipoInspEstuDesoController.stream;

  Sink get sinkValidateTipoInspEstuDeso =>
      _validateTipoInspEstuDesoController.sink;

  bool get tipoInspEstuDeso => _validateTipoInspEstuDesoController.value;

  final _validateControleDeQuantidadeController = BehaviorSubject<bool>();

  Stream<bool> get outValidateControleDeQuantidade =>
      _validateControleDeQuantidadeController.stream;

  Sink get sinkValidateControleDeQuantidade =>
      _validateControleDeQuantidadeController.sink;

  bool get controleDeQuantidade =>
      _validateControleDeQuantidadeController.value;

  final _validatePesoSacasController = BehaviorSubject<bool>();

  Stream<bool> get outValidatePesoSacas => _validatePesoSacasController.stream;

  Sink get sinkValidatePesoSacas => _validatePesoSacasController.sink;

  bool get pesoSacas => _validatePesoSacasController.value;

  final _descricaoEmbalagemController = BehaviorSubject<String>();

  Stream<String> get outDescricaoEmbalagem =>
      _descricaoEmbalagemController.stream.transform(validateVazio);

  final _planosAmostragemController = BehaviorSubject<String>();

  Stream<String> get outPlanosAmostragem =>
      _planosAmostragemController.stream.transform(validateVazio);

  final _identificacaoDosVolumesController = BehaviorSubject<String>();

  Stream<String> get outIdentificacaoDosVolumes =>
      _identificacaoDosVolumesController.stream;

  final _doubleCheckController = BehaviorSubject<int>();

  Stream<int> get outDoubleCheck => _doubleCheckController.stream;

  Sink get sinkDoubleCheck => _doubleCheckController.sink;

  final _empresaController = BehaviorSubject<String>();

  Stream<String> get outEmpresa =>
      _empresaController.stream.transform(validateVazio);

  final _lacreDasAmostrasController = BehaviorSubject<String>();

  Stream<String> get outLacreDasAmostras => _lacreDasAmostrasController.stream;

  final _resumoController = BehaviorSubject<String>();

  Stream<String> get outResumo =>
      _resumoController.stream.transform(validateVazio);

  final _validateInspEstDesoController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outAutoValidateInspEstuDeso =>
      _validateInspEstDesoController.stream;

  Sink<bool> get inAutoValidateInspEstuDeso =>
      _validateInspEstDesoController.sink;

  final _validateInspEstDesoInfoContainerController =
      BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outAutoValidateInspEstuDesoInfoContainer =>
      _validateInspEstDesoInfoContainerController.stream;

  Sink<bool> get inAutoValidateInspEstuDesoInfoContainer =>
      _validateInspEstDesoInfoContainerController.sink;

  final _validateInspEstDesoResumoQtdController =
      BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outAutoValidateInspEstuDesoResumoQtd =>
      _validateInspEstDesoResumoQtdController.stream;

  Sink<bool> get inAutoValidateInspEstuDesoResumoQtd =>
      _validateInspEstDesoResumoQtdController.sink;

  //---------------------------------------------------------------------------------------
  // ON CHANGE

  Function(DateTime) get changeDataHoraInicioInspecao =>
      _dataHoraInicioInspecaoController.sink.add;

  Function(DateTime) get changeDataHoraFimInspecao =>
      _dataHoraFimInspecaoController.sink.add;

  Function(DateTime) get changeDataHoraInicioEstuDeso =>
      _dataHoraInicioInspecaoController.sink.add;

  Function(DateTime) get changeDataHoraFimEstuDeso =>
      _dataHoraFimInspecaoController.sink.add;

  //---------------------------------------------------------------------------------------------------
  // CONTAINERS REGISTRADOS CONTROLLERS
  //---------------------------------------------------------------------------------------------------
  final _numeroDoContainerController = BehaviorSubject<String>();

  Stream<String> get outNumeroDoContainer =>
      _numeroDoContainerController.stream.transform(validateVazio);

  final _taraController = BehaviorSubject<String>();

  Stream<String> get outTara => _taraController.stream.transform(validateVazio);

  Sink get sinkTara => _taraController.sink;

  final _capacidadeController = BehaviorSubject<String>();

  Stream<String> get outCapacidade =>
      _capacidadeController.stream.transform(validateVazio);

  final _dataFabricacaoController = BehaviorSubject<DateTime>();

  Stream<String> get outDataFabricacao =>
      _dataFabricacaoController.stream.transform(validateDateTime);

  final _condicaoController = BehaviorSubject<int>();

  Stream<int> get outCondicao => _condicaoController.stream;

  Sink get sinkCondicao => _condicaoController.sink;

  final _razaoRejeicaoController = BehaviorSubject<String>();

  Stream<String> get outRazaoRejeicao =>
      _razaoRejeicaoController.stream.transform(validateVazio);

  final _temperaturaController = BehaviorSubject<String>();

  Stream<String> get outTemperatura =>
      _temperaturaController.stream.transform(validateVazio);

  final _lacreSgs7MetrosController = BehaviorSubject<String>();

  Stream<String> get outLacreSgs7Metros => _lacreSgs7MetrosController.stream;

  final _lacreDefinitivoController = BehaviorSubject<String>();

  Stream<String> get outLacreDefinitivo => _lacreDefinitivoController.stream;

  final _lacreAgenciaController = BehaviorSubject<String>();

  Stream<String> get outLacreAgencia => _lacreAgenciaController.stream;

  final _lacreOutrosController = BehaviorSubject<String>();

  Stream<String> get outLacreOutros => _lacreOutrosController.stream;

  final _loteController = BehaviorSubject<String>();

  Stream<String> get outLote => _loteController.stream.transform(validateVazio);

  final _provisorioController = BehaviorSubject<String>();

  Stream<String> get outProvisorio => _provisorioController.stream.transform(validateVazio);

  final _dataLoteController = BehaviorSubject<DateTime>();

  Stream<String> get outDataLote =>
      _dataLoteController.stream.transform(validateDateTime);

  final _listControleDeQuantidadeController = BehaviorSubject<List<String>>();

  Stream<List<String>> get outListControleDeQuant =>
      _listControleDeQuantidadeController.stream;

  Sink<List<String>> get sinkListControleDeQuant =>
      _listControleDeQuantidadeController.sink;
  List<String> listAuxControleDeQuantidade = [];

  final _listPesoSacasController = BehaviorSubject<List<String>>();

  Stream<List<String>> get outListPesoSacas => _listPesoSacasController.stream;

  Sink<List<String>> get sinkPesoSacas => _listPesoSacasController.sink;

  List<String> listAuxPesoSacas = [];

  //ON CHANGE
//--------
  Function(String) get changeMatricula => _matriculaController.sink.add;

  Sink<String> get sinkMatricula => _matriculaController.sink;

  Function(String) get changeOrdemDeServico => _osController.sink.add;

  Sink<String> get sinkOrdemDeServico => _osController.sink;

  Function(String) get changeClientePrincipal =>
      _clientePrincipalController.sink.add;

  Sink<String> get sinkClientePrincipal => _clientePrincipalController.sink;

  Function(String) get changeLocalTerminal => _localTerminalController.sink.add;

  Sink<String> get sinkLocalTerminal => _localTerminalController.sink;

  Function(String) get changeBooking => _bookingController.sink.add;

  Sink<String> get sinkBooking => _bookingController.sink;

  Function(String) get changeNavio => _navioController.sink.add;

  Sink<String> get sinkNavio => _navioController.sink;

  Function(String) get changeIdentificacaoDoEquipamento =>
      _identificacaoEquipamentoController.sink.add;

  Sink<String> get sinkIdentificacaoDoEquipamento =>
      _identificacaoEquipamentoController.sink;

  Function(String) get changeNumeroDoCertificado =>
      _numeroCertificadoController.sink.add;

  Sink<String> get sinkNumeroDoCertificado => _numeroCertificadoController.sink;

  Function(DateTime) get changeDataVerificacao => _dataVerificacaoController.sink.add;

  Sink<DateTime> get sinkDataVerificacao => _dataVerificacaoController.sink;

  Function(String) get changeDescricaoEmbalagem =>
      _descricaoEmbalagemController.sink.add;

  Sink<String> get sinkDescricaoEmbalagem => _descricaoEmbalagemController.sink;

  Function(String) get changePlanoDeAmostragem =>
      _planosAmostragemController.sink.add;

  Sink<String> get sinkPlanoDeAmostragem => _planosAmostragemController.sink;

  Function(String) get changeIdentificacaoDosVolumes =>
      _identificacaoDosVolumesController.sink.add;

  Sink<String> get sinkIdentificacaoDosVolumes =>
      _identificacaoDosVolumesController.sink;

  Function(String) get changeEmpresa => _empresaController.sink.add;

  Sink<String> get sinkEmpresa => _empresaController.sink;

  Function(String) get changeLacreDasAmostras =>
      _lacreDasAmostrasController.sink.add;

  Sink<String> get sinkLacreDasAmostras => _lacreDasAmostrasController.sink;

  Function(String) get changeNumeroDoContainer =>
      _numeroDoContainerController.sink.add;

  Function(String) get changeCapacidade => _capacidadeController.sink.add;

  Function(DateTime) get changeDataDeFabricacao =>
      _dataFabricacaoController.sink.add;

  Function(String) get changeRazaoDaRejeicao =>
      _razaoRejeicaoController.sink.add;

  Function(String) get changeTemperatura => _temperaturaController.sink.add;

  Function(String) get changeSGS7Metros => _lacreSgs7MetrosController.sink.add;

  Function(String) get changeSGSDefinitivo =>
      _lacreDefinitivoController.sink.add;

  Function(String) get changeAgencia => _lacreAgenciaController.sink.add;

  Function(String) get changeOutros => _lacreOutrosController.sink.add;

  Function(String) get changeLote => _loteController.sink.add;

  Function(String) get changeProvisorio => _provisorioController.sink.add;

  Function(DateTime) get changeDataDoLote => _dataLoteController.sink.add;

  Function(String) get changeResumo => _resumoController.sink.add;

  Sink<String> get sinkResumo => _resumoController.sink;

  //---------------------------------------------------------------------------------------------------
  // TIMELOGS CONTROLLERS
  //---------------------------------------------------------------------------------------------------

  final _listTimeLogsController = BehaviorSubject<Formulario>();

  Stream<Formulario> get outListTimeLogs => _listTimeLogsController.stream;

  Sink get sinkListTimeLogs => _listTimeLogsController.sink;

  List<TimeLogs> get getListTimeLogs =>
      _listInicialTimeLogsController.stream.value;


  final _selecionarDataInicioController = BehaviorSubject<DateTime>();

  Stream<String> get outSelecionarInicioData =>
      _selecionarDataInicioController.stream.transform(validateDateTime);

  final _selecionarDataTerminoController = BehaviorSubject<DateTime>();

  Stream<String> get outSelecionarTerminoData =>
      _selecionarDataTerminoController.stream.transform(validateDateTime);

  final _ocorrenciaController = BehaviorSubject<String>();

  Stream<String> get outOcorrencia =>
      _ocorrenciaController.stream.transform(validateVazio);

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

  //---------------------------------------------------------------------------------------------------
  // SUPERVISAO DE PESO CONTROLLERS
  //---------------------------------------------------------------------------------------------------

  final _marcaDaBalancaController = BehaviorSubject<String>();

  Stream<String> get outMarcaDaBalanca =>
      _marcaDaBalancaController.stream.transform(validateVazio);

  final _numeroDeSerieController = BehaviorSubject<String>();

  Stream<String> get outNumeroDeSerie =>
      _numeroDeSerieController.stream.transform(validateVazio);

  final _ultimaCalibracaoController = BehaviorSubject<DateTime>();

  Stream<String> get outUltimaCalibracao =>
      _ultimaCalibracaoController.stream.transform(validateDateTime);

  final _numeroDeLacreController = BehaviorSubject<String>();

  Stream<String> get outNumeroDeLacre =>
      _numeroDeLacreController.stream.transform(validateVazio);

  final _mediaController = BehaviorSubject<String>();

  Stream<String> get outMedia =>
      _mediaController.stream.transform(validateVazio);

  Sink get sinkMedia => _mediaController.sink;

  final _taraDaUnidadeController = BehaviorSubject<String>();

  Stream<String> get outTaraDaUnidade =>
      _taraDaUnidadeController.stream.transform(validateVazio);

  Sink<String> get sinkTaraDaUnidade => _taraDaUnidadeController.sink;

  String get valueMedia => mediaPesoSacas();

  String get valueMediaText => _mediaController.stream.value;

  /*Stream<String> get outTaraDaUnidade =>
      _taraDaUnidadeController.stream.transform(validateVazio);*/

  final _companhiaController = BehaviorSubject<String>();

  Stream<String> get outCompanhia =>
      _companhiaController.stream.transform(validateVazio);

  final _frontController = BehaviorSubject<String>();

  Stream<String> get outFront =>
      _frontController.stream.transform(validateVazio);

  final _backController = BehaviorSubject<String>();

  Stream<String> get outBack => _backController.stream.transform(validateVazio);

  final _inkjetController = BehaviorSubject<String>();

  Stream<String> get outInkjet =>
      _inkjetController.stream.transform(validateVazio);

  final _validateSupervisaoPesoController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateSupervisaoPeso =>
      _validateSupervisaoPesoController.stream;

  // ON CHANGE
//----------------

  Function(String) get changeMarcaDaBalanca =>
      _marcaDaBalancaController.sink.add;

  Sink<String> get inMarcaBalanca => _marcaDaBalancaController.sink;

  Function(String) get changNumeroDeSerie => _numeroDeSerieController.sink.add;

  Sink<String> get inNumeroDeSerie => _numeroDeSerieController.sink;

  Function(DateTime) get changeUltimaCalibracao =>
      _ultimaCalibracaoController.sink.add;

  Sink<DateTime> get inUltimaCalibracao => _ultimaCalibracaoController.sink;

  Function(String) get changNumeroDeLacre => _numeroDeLacreController.sink.add;

  Sink<String> get inNumeroDeLacre => _numeroDeLacreController.sink;

  Function(String) get changMedia => _mediaController.sink.add;

  Sink<String> get inMediaSupervisao => _mediaController.sink;

  Function(String) get changCompanhia => _companhiaController.sink.add;

  Sink<String> get inCompanhia => _companhiaController.sink;

  Function(String) get changFront => _frontController.sink.add;

  Sink<String> get inFront => _frontController.sink;

  Function(String) get changBack => _backController.sink.add;

  Sink<String> get inBack => _backController.sink;

  Function(String) get changInkjet => _inkjetController.sink.add;

  Sink<String> get inInkjet => _inkjetController.sink;

  Sink<bool> get inAutoValidateSupervisaoPeso =>
      _validateSupervisaoPesoController.sink;

  //---------------------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------------
  // QUEBRA DE NOTA CONTROLLERS
  //---------------------------------------------------------------------------------------------------

  final _notaFiscalController = BehaviorSubject<String>();

  Stream<String> get outNotaFiscal =>
      _notaFiscalController.stream.transform(validateVazio);

  final _placaController = BehaviorSubject<String>();

  Stream<String> get outPlaca =>
      _placaController.stream.transform(validateVazio);

  final _totalDeSacasController = BehaviorSubject<String>();

  Stream<String> get outTotalDeSacas =>
      _totalDeSacasController.stream.transform(validateVazio);

  Sink<String> get sinkTotalDeSacas => _totalDeSacasController.sink;

  final _totalPorContainerController = BehaviorSubject<String>();

  Stream<String> get outTotalPorContainer =>
      _totalPorContainerController.stream.transform(validateVazio);

  Sink<String> get sinkTotalPorContainer => _totalPorContainerController.sink;

  final _sobraController = BehaviorSubject<String>();

  Stream<String> get outSobra =>
      _sobraController.stream.transform(validateVazio);

  Sink<String> get sinkSobra => _sobraController.sink;

  final _avariaController = BehaviorSubject<String>();

  Stream<String> get outAvaria => _avariaController.stream;

  final _faltaCargaController = BehaviorSubject<String>();

  Stream<String> get outFaltaCarga => _faltaCargaController.stream;

  final _observacaoController = BehaviorSubject<String>();

  Stream<String> get outObservacao => _observacaoController.stream;

  final _validateQuebraNotaController = BehaviorSubject<bool>();

  Stream<bool> get outAutoValidateQuebraNota =>
      _validateQuebraNotaController.stream;

  //---------------------------------------------------------------------------------------------------

  // ON CHANGE
//----------------

  Function(String) get changeNotaFiscal => _notaFiscalController.sink.add;

  Function(String) get changePlaca => _placaController.sink.add;

  Function(String) get changeAvaria => _avariaController.sink.add;

  Function(String) get changeFaltaCarga => _faltaCargaController.sink.add;

  Function(String) get changeObservacao => _observacaoController.sink.add;

  Sink<bool> get inAutoValidateQuebraNota => _validateQuebraNotaController.sink;

  //---------------------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------------
  // ASSINATURA DIGITAL CONTROLLERS
  //---------------------------------------------------------------------------------------------------

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
// TODO #04- Modificar a form aqui
  Future<bool> salvarInspecaoEstufagemDesova(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();

      final blocProduto =
          BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();

      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          form.dadoscontainer.inspecao = _inspecaoController.value;
          form.dadoscontainer.estufagem = _estufagemController.value;
          form.dadoscontainer.desova = _desovaController.value;
          if (form.dadoscontainer.inspecao){
            /// DATA / HORA INICIO E FIM INSPECAO
            form.dadoscontainer.dataHoraInicioInspecao = DateFormat('dd/MM/yyyy HH:mm:ss').format(_dataHoraInicioInspecaoController.value);
            form.dadoscontainer.dataHoraFimInspecao = DateFormat('dd/MM/yyyy HH:mm:ss').format(_dataHoraFimInspecaoController.value);
          }
          if (form.dadoscontainer.estufagem || form.dadoscontainer.desova){
            /// DATA / HORA INICIO E FIM ESTUFAGEM DESOVA
          }
          form.nomeFormulario = _bookingController.value;
          form.dadoscontainer.matricula = _matriculaController.value;
          form.dadoscontainer.ordemServico = _osController.value;
          form.dadoscontainer.clientePrincipal = _clientePrincipalController.value;
          form.dadoscontainer.localTerminal = _localTerminalController.value;
          if (form.dadoscontainer.estufagem || form.dadoscontainer.desova)
          form.dadoscontainer.produto = blocProduto.valueProdutoInspEstuDesova;
          form.dadoscontainer.booking = _bookingController.value;
          form.dadoscontainer.navio = _navioController.value;
          if (form.dadoscontainer.estufagem || form.dadoscontainer.desova) {
            form.dadoscontainer.identificacaoEquipamento = _identificacaoEquipamentoController.value;
            form.dadoscontainer.numeroCertificado =_numeroCertificadoController.value;
            form.dadoscontainer.dataVerificacao = DateFormat('dd/MM/yyyy').format(_dataVerificacaoController.value);
            form.dadoscontainer.descricaoEmbalagem = _descricaoEmbalagemController.value;
            form.dadoscontainer.planoAmostragem =_planosAmostragemController.value;
            form.dadoscontainer.identificacaoDosVolumes = _identificacaoDosVolumesController.value;
            form.dadoscontainer.doubleCheck = _doubleCheckController.value == 1 ? true : false;
            if(form.dadoscontainer.doubleCheck){
              form.dadoscontainer.empresa = _empresaController.value;
              form.dadoscontainer.lacreDasAmostras =
              (_lacreDasAmostrasController.value != null &&
                  _lacreDasAmostrasController.value.isNotEmpty)
                  ? int.parse(_lacreDasAmostrasController.value)
                  : 0;
            }
          }

          form.dadoscontainer.resumo = _resumoController.value;

          if (form.dadoscontainer.containersRegistrados == null ||
              form.dadoscontainer.containersRegistrados.isEmpty) {
            form.dadoscontainer.containersRegistrados = [
              adicionarInformacoesContainer()
            ];
          } else {
            form.dadoscontainer.containersRegistrados
                .add(adicionarInformacoesContainer());
          }
        }
      });

      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkFormularioInicial.add(formulario);
      formulario.container.forEach((dadosContainer) {
        if (dadosContainer.uuid == uuid) {
          sinkListInicialInspecaoEstufagemDesova
              .add(dadosContainer.dadoscontainer.containersRegistrados);
        }
      });
      carregarNumeroContainer(uuid: uuid);
      return true;
    } catch (e) {
      return false;
    }
  }

  carregarNumeroContainer({uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    final blocNumeroDoContainer =
        BlocProvider.tag('container').getBloc<DropDowBlocNumeroDoContainer>();

    blocNumeroDoContainer.sinkListNumeroDosContainers.add([]);

    formulario.container.forEach((form) {
      if (form.uuid == uuid &&
          form.dadoscontainer.containersRegistrados != null) {
        form.dadoscontainer.containersRegistrados.forEach((container) {
          blocNumeroDoContainer
              .getListNumeroDoContainer(container.numeroContainer);
        });
      }
      formulario.container.forEach((dados) {
        if (dados.uuid == uuid &&
            dados.dadoscontainer.quebraNotasFiscais != null) {
          dados.dadoscontainer.quebraNotasFiscais.forEach((quebraNota) {
//            blocNumeroDoContainer.listValueContainer.removeWhere(
//                    (valueNumero) => valueNumero == quebraNota.container);

            blocNumeroDoContainer.sinkListNumeroDosContainers
                .add(blocNumeroDoContainer.listValueContainer);
          });
        }
      });
    });
  }

  Future<bool> salvarTimeLogs(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();

      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadoscontainer.timeLogs == null ||
              form.dadoscontainer.timeLogs.isEmpty) {
            form.dadoscontainer.timeLogs = [adicionarTimeLogs()];
          } else {
            form.dadoscontainer.timeLogs.add(adicionarTimeLogs());
          }
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      formulario.container.forEach((dados) {
        if (dados.uuid == uuid) {
          sinkListInicialTimeLogs.add(dados.dadoscontainer.timeLogs);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarSupervisaoDePeso(uuid) async {
    try {
      final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          form.dadoscontainer.usinaSP = blocUsina.valueSupervisaoPeso;
          form.dadoscontainer.marcaDaBalanca = _marcaDaBalancaController.value;
          form.dadoscontainer.numeroDeSerie = _numeroDeSerieController.value;
          form.dadoscontainer.numeroDoLacre = _numeroDeLacreController.value;
          form.dadoscontainer.ultimaCalibracao =
              _ultimaCalibracaoController.value.toString();
          form.dadoscontainer.companhia = _companhiaController.value;

          form.dadoscontainer.pesoSacas =
              convertStringToDouble(_listPesoSacasController.value);
          form.dadoscontainer.totalKg = double.parse(totalPesoSacas());
          form.dadoscontainer.unidadesPesadas =
              int.parse(unidadesPesadasPesoSacas());
          form.dadoscontainer.mediaDoPesoLiquido = double.parse(pesoLiquido);

          form.dadoscontainer.taraDaUnidade =
              (_taraDaUnidadeController.value == null ||
                      _taraDaUnidadeController.value.isEmpty)
                  ? 0.0
                  : double.parse(_taraDaUnidadeController.value);

          form.dadoscontainer.media =
              double.parse(_mediaController.stream.value);

          form.dadoscontainer.front = _frontController.value;
          form.dadoscontainer.back = _backController.value;
          form.dadoscontainer.inkjet = _inkjetController.value;
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkFormularioInicial.add(formulario);
      sugarBloc.sinkLisInicial.add(formulario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarQuebraDeNota(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();

      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          form.dadoscontainer.quebraNotasFiscais = adicionarQuebraDeNota(form);

          sinkListInicialQuebraDeNota
              .add(form.dadoscontainer.quebraNotasFiscais);
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> salvarAssinaturaDigital(uuid) async {
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          form.dadoscontainer.inspetorSgs = _assinaturaInspetorBloc.value;
          form.dadoscontainer.terminal = _assinaturaTerminalBloc.value;
        }
      });
      sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
      sugarBloc.sinkLisInicial.add(formulario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sincronizarContainer(uuid) async {
    _isSaveController.add(true);
    final bloc = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
    try {
      Formulario formulario = await sugarBloc.getFormularioSugar();
      Map<String, dynamic> sincronizarContainer;

      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          form.status = 'SINCRONIZADO';
          sincronizarContainer = SincronizarContainer(
                  idUsuario: formulario.idUsuario,
                  login: formulario.login,
                  status: 1,
                  tipoFormulario: bloc.valueIdFormAtualSincronizado,
                  container: form
          ).toJson();
        }
      });

      bool sincronizado = await sugarBloc.sincronizarService(
          status: 1,
          tipoFormulario: bloc.valueIdFormAtualSincronizado,
          formulario: sincronizarContainer, tipo: 2);

      if (sincronizado) {
        formulario.container.removeWhere((container) => container.uuid == uuid);
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
      print(e);
      return false;
    }
  }

  InformacaoContainer adicionarInformacoesContainer() {
    InformacaoContainer inf = InformacaoContainer.padrao();

    inf.numeroContainer = _numeroDoContainerController.value;

    inf.tara =
        (_taraController.value != null && _taraController.value.isNotEmpty)
            ? double.parse(_taraController.value)
            : 0.0;

    inf.capacidade = (_capacidadeController.value != null &&
            _capacidadeController.value.isNotEmpty)
        ? int.parse(_capacidadeController.value)
        : 0;

    inf.dataFabricacao = _dataFabricacaoController.value.toString();
    inf.condicao = (_condicaoController.value == 1) ? true : false;
    if(!inf.condicao){
      inf.razaoRejeicao = _razaoRejeicaoController.value;
    }
    inf.temperatura = _temperaturaController.value;
    inf.lacreSgs7Metros = (_lacreSgs7MetrosController.value != null &&
            _lacreSgs7MetrosController.value.isNotEmpty)
        ? int.parse(_lacreSgs7MetrosController.value)
        : 0;

    inf.lacreDefinitivo = (_lacreDefinitivoController.value != null &&
            _lacreDefinitivoController.value.isNotEmpty)
        ? int.parse(_lacreDefinitivoController.value)
        : 0;

    inf.lacreAgencia = _lacreAgenciaController.value;

    inf.lacreOutros = (_lacreOutrosController.value != null &&
            _lacreOutrosController.value.isNotEmpty)
        ? int.parse(_lacreOutrosController.value)
        : 0;

    inf.lote = _loteController.value.toString();
    //inf.data = _dataLoteController.value.toString();
    //inf.controleDeQuantidade =
    //    convertStringToInt(_listControleDeQuantidadeController.value);
    //inf.total = int.parse(totalControleQuant());

    return inf;
  }

  TimeLogs adicionarTimeLogs() {
    TimeLogs timeLogs = TimeLogs.padrao();

    timeLogs.dataInicial = _selecionarDataInicioController.value.toString();
    timeLogs.dataTermino = _selecionarDataTerminoController.value.toString();
    timeLogs.ocorrencia = _ocorrenciaController.value;

    return timeLogs;
  }

  List<QuebraNotasFiscais> adicionarQuebraDeNota(Container form) {
    QuebraNotasFiscais quebraNotasFiscais = QuebraNotasFiscais.padrao();
    List<QuebraNotasFiscais> listNFs = [];
    int cont = 0;
    int tamanhoForm = form.dadoscontainer.quebraNotasFiscais == null
        ? 0
        : form.dadoscontainer.quebraNotasFiscais.length;

    final blocNumeroDoContainer =
        BlocProvider.tag('container').getBloc<DropDowBlocNumeroDoContainer>();

    if (form.dadoscontainer.quebraNotasFiscais != null &&
        form.dadoscontainer.quebraNotasFiscais.isNotEmpty) {
      form.dadoscontainer.quebraNotasFiscais.forEach((quebraNotaFiscal) {
        if (quebraNotaFiscal.container ==
            blocNumeroDoContainer.valueNumeroContainer) {
          quebraNotaFiscal.quebraNotas.add(adicionarQuebraNotaFiscal());
          quebraNotasFiscais = quebraNotaFiscal;
          listNFs.add(quebraNotasFiscais);
        } else {
          cont++;
          listNFs.add(quebraNotaFiscal);
        }
      });
    } else {
      quebraNotasFiscais.container = blocNumeroDoContainer.valueNumeroContainer;
      quebraNotasFiscais.quebraNotas = [adicionarQuebraNotaFiscal()];
      listNFs.add(quebraNotasFiscais);
      cont++;
    }

    if (cont == tamanhoForm) {
      quebraNotasFiscais.container = blocNumeroDoContainer.valueNumeroContainer;
      quebraNotasFiscais.quebraNotas = [adicionarQuebraNotaFiscal()];
      listNFs.add(quebraNotasFiscais);
    }

    return listNFs;
  }

  QuebraNota adicionarQuebraNotaFiscal() {
    final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
    final blocTipoAcucar =
        BlocProvider.tag('sugarGlobal').getBloc<TipoAcucarBloc>();
    QuebraNota nota = QuebraNota.padrao();

    nota.notaFiscal = _notaFiscalController.value;
    nota.placa = _placaController.value;
    nota.usina = blocUsina.valueQuebraNota;
    nota.tipoDeAcucar = blocTipoAcucar.valueTipoAcucarQuebraDeNota;
    nota.totalPorContainer =
        double.parse(_totalPorContainerController.stream.value.replaceAll(',', ''));
    nota.totalDeSacas = double.parse(_totalDeSacasController.stream.value.replaceAll(',', ''));
    nota.sobra = _sobraController.value;
    nota.avaria = _avariaController.value;
    nota.faltaCarga = _faltaCargaController.value;
    nota.observacao = _observacaoController.value;
    return nota;
  }

  excluirTimeLogs({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.container.forEach((dadosContainer) {
      if (dadosContainer.uuid == uuid) {
        dadosContainer.dadoscontainer.timeLogs.removeAt(indice);

        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListInicialTimeLogs.add(dadosContainer.dadoscontainer.timeLogs);
      }
    });
  }

  excluirInspEstufDesova({@required indice, @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.container.forEach((dadosContainer) {
      if (dadosContainer.uuid == uuid) {
        dadosContainer.dadoscontainer.containersRegistrados.removeAt(indice);
        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);
        sinkListInicialInspecaoEstufagemDesova
            .add(dadosContainer.dadoscontainer.containersRegistrados);
      }
    });
  }

  excluirQuebraDeNota(
      {@required indicePrincipal,
      @required indiceQuebraNota,
      @required uuid}) async {
    Formulario formulario = await sugarBloc.getFormularioSugar();

    formulario.container.forEach((dadosContainer) {
      if (dadosContainer.uuid == uuid) {
        if (dadosContainer.dadoscontainer.quebraNotasFiscais[indicePrincipal]
                    .quebraNotas.length ==
                1 ||
            dadosContainer.dadoscontainer.quebraNotasFiscais[indicePrincipal]
                .quebraNotas.isEmpty) {
          dadosContainer.dadoscontainer.quebraNotasFiscais
              .removeAt(indicePrincipal);
        } else {
          dadosContainer
              .dadoscontainer.quebraNotasFiscais[indicePrincipal].quebraNotas
              .removeAt(indiceQuebraNota);
        }

        sugarBloc.salvarFormularioSugar(formularioSugar: formulario);

        sinkListInicialQuebraDeNota
            .add(dadosContainer.dadoscontainer.quebraNotasFiscais);
      }
    });
    carregarNumeroContainer(uuid: uuid);
  }

  static List<String> convertIntToString(List<int> list) {
    List<String> values = [];
    list.forEach((value) {
      values.add(value.toString());
    });
    return values;
  }

  static List<int> convertStringToInt(List<String> list) {
    List<int> values = [];
    list.forEach((value) {
      values.add(int.parse(value));
    });
    return values;
  }

  static List<double> convertStringToDouble(List<String> list) {
    List<double> values = [];
    list.forEach((value) {
      values.add(double.parse(value));
    });
    return values;
  }

  static List<String> convertDoubleToString(List<double> list) {
    List<String> values = [];
    list.forEach((value) {
      values.add(value.toString());
    });
    return values;
  }

  String totalControleQuant() {
    int total = 0;
    listAuxControleDeQuantidade.forEach((v) {
      total += int.parse(v);
    });
    return total.toString();
  }

  String unidadesControleQuant() {
    int total = 0;
    total = listAuxControleDeQuantidade.length;
    return total.toString();
  }

  String totalPesoSacas() {
    double total = 0.0;
    listAuxPesoSacas.forEach((v) {
      total += double.parse(v);
    });
    return total.toStringAsFixed(3);
  }

  String unidadesPesadasPesoSacas() {
    int total = 0;
    total = listAuxPesoSacas.length;
    return total.toString();
  }

  String mediaPesoSacas() {
    double total = 0.000;
    listAuxPesoSacas.forEach((v) {
      total += double.parse(v);
    });
    total = total / listAuxPesoSacas.length;
    return listAuxPesoSacas.length == 0 ? "" : total.toStringAsFixed(3);
  }

  String MediaPesoLiquido({@required media, @required tara}) {
    var mediaPesoLiquido = (media == null || media
        .toString()
        .isEmpty
            ? 0.0
            : double.parse(media) -
                (tara == null || tara.toString().isEmpty
                    ? 0.0
                    : double.parse(tara)))
        .toStringAsFixed(3);
    pesoLiquido = mediaPesoLiquido;
    return mediaPesoLiquido;
  }

  Future<bool> validateSupervisaoPeso(uuid) async {
    try {
      bool validado = true;
      Formulario formulario = await sugarBloc.getFormularioSugar();
      formulario.container.forEach((form) {
        if (form.uuid == uuid) {
          if (form.dadoscontainer.usinaSP == null) {
            validado = false;
          }
          if (form.dadoscontainer.marcaDaBalanca == null) {
            validado = false;
          }
        }
      });
      return validado;
    } catch (e) {
      return false;
    }
  }

  bool validateTipoInspDeso() {
    if (_inspecaoController.stream.value == false &&
        _estufagemController.stream.value == false &&
        _desovaController.stream.value == false) {
      return true;
    } else {
      return false;
    }
  }

  bool validateControleDeQuantidade() {
    if (listAuxControleDeQuantidade.length <= 0) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePesoSacas() {
    if (listAuxPesoSacas.length <= 0) {
      return true;
    } else {
      return false;
    }
  }

  validateSinkTipoInspEstuDeso() {
    bool tipo = validateTipoInspDeso();
    if (tipo) {
      sinkValidateTipoInspEstuDeso.add(true);
    } else {
      sinkValidateTipoInspEstuDeso.add(false);
    }
  }

  @override
  void dispose() {
    _isSaveController.close();
    _listInicialInspecaoEstufagemDesovaController.close();
    _listInicialTimeLogsController.close();
    _listInicialQuebraDeNotaController.close();
    _inspecaoController.close();
    _estufagemController.close();
    _desovaController.close();
    _inspetorController.close();
    _matriculaController.close();
    _osController.close();
    _clientePrincipalController.close();
    _localTerminalController.close();
    _bookingController.close();
    _navioController.close();
    _identificacaoEquipamentoController.close();
    _numeroCertificadoController.close();
    _dataVerificacaoController.close();
    _descricaoEmbalagemController.close();
    _planosAmostragemController.close();
    _identificacaoDosVolumesController.close();
    _doubleCheckController.close();
    _empresaController.close();
    _lacreDasAmostrasController.close();
    _resumoController.close();
    _numeroDoContainerController.close();
    _taraController.close();
    _capacidadeController.close();
    _dataFabricacaoController.close();
    _condicaoController.close();
    _razaoRejeicaoController.close();
    _temperaturaController.close();
    _lacreSgs7MetrosController.close();
    _lacreDefinitivoController.close();
    _lacreAgenciaController.close();
    _lacreOutrosController.close();
    _loteController.close();
    _dataLoteController.close();
    _selecionarDataTerminoController.close();
    _ocorrenciaController.close();
    _assinaturaInspetorBloc.close();
    _assinaturaTerminalBloc.close();
    _listControleDeQuantidadeController.close();
    _validateInspEstDesoController.close();
    _validateTipoInspEstuDesoController.close();
    _validateSupervisaoPesoController.close();
    _validateQuebraNotaController.close();
    _validateInspEstDesoInfoContainerController.close();
    _validateInspEstDesoResumoQtdController.close();
    _validaAssinaturaInspetorBloc.close();
    _validaAssinaturaTerminalBloc.close();
    _validateControleDeQuantidadeController.close();
    _listQuebraDeNotaController.close();
    _listInspEstufDesovaController.close();
    _listTimeLogsController.close();
    _validatePesoSacasController.close();
    _listPesoSacasController.close();
    _selecionarDataInicioController.close();
    _validateTimeLogsController.close();
    _marcaDaBalancaController.close();
    _numeroDeSerieController.close();
    _ultimaCalibracaoController.close();
    _numeroDeLacreController.close();
    _mediaController.close();
    _taraDaUnidadeController.close();
    _companhiaController.close();
    _frontController.close();
    _backController.close();
    _inkjetController.close();
    _notaFiscalController.close();
    _placaController.close();
    _totalDeSacasController.close();
    _totalPorContainerController.close();
    _sobraController.close();
    _avariaController.close();
    _faltaCargaController.close();
    _observacaoController.close();

    super.dispose();
  }
}
