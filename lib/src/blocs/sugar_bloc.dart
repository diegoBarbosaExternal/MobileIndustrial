import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/file_bloc.dart';
import 'package:sugar/src/blocs/login_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/dados_breakbulk.dart';
import 'package:sugar/src/models/dados_container.dart';
import 'package:sugar/src/models/container.dart' as ContModel;
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/login_model.dart';
import 'package:sugar/src/models/sincronizado.dart';
import 'package:sugar/src/models/sugar_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sugar/src/services/sugar_service.dart';
import 'package:uuid/uuid.dart';

class SugarBloc implements BlocBase {
  final _statusTela = BehaviorSubject<String>();

  Stream<String> get outStatusTela => _statusTela.stream;

  Sink<String> get sinkStatusTela => _statusTela.sink;

  String statusTela;

  // UUID

  final _uuidFormAtualController = BehaviorSubject<String>();

  Stream<String> get outUUIDFormAtual => _uuidFormAtualController.stream;

  Sink<String> get sinkUUIDFormAtual => _uuidFormAtualController.sink;

  String get valueUUIDFormAtual => _uuidFormAtualController.stream.value;

  final _listInicialController = BehaviorSubject<Formulario>();

  Stream<Formulario> get outListInicial => _listInicialController.stream;

  Sink get sinkLisInicial => _listInicialController.sink;

  final _formularioInicialController = BehaviorSubject<Formulario>();

  Stream<Formulario> get outFormularioInicial =>
      _formularioInicialController.stream;

  Sink<Formulario> get sinkFormularioInicial =>
      _formularioInicialController.sink;

  // ID do tipo formulario que será sincronizado

  final _idFormAtualSincronizadoController = BehaviorSubject<int>();

  Stream<int> get outIdFormAtualSincronizado =>
      _idFormAtualSincronizadoController.stream;

  Sink<int> get sinkIdFormAtualSincronizado =>
      _idFormAtualSincronizadoController.sink;

  int get valueIdFormAtualSincronizado =>
      _idFormAtualSincronizadoController.stream.value;

  Formulario get getFormAtual => _formularioInicialController.stream.value;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _statusTela.close();
    _uuidFormAtualController.close();
    _listInicialController.close();
    _formularioInicialController.close();
    _idFormAtualSincronizadoController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

  Future<void> getSugarDropDown() async {
    final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
    final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
    final blocTipoUsina =
        BlocProvider.tag('sugarGlobal').getBloc<TipoUsinaBloc>();
    final blocTipoAcucar =
        BlocProvider.tag('sugarGlobal').getBloc<TipoAcucarBloc>();

    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel user = await blocLogin.getUser();

    String jsonSugar =
        await FileBloc.readData(tipo: file.SUGAR, nomeFile: user.idUsuario);
    final sugarModel = sugarModelFromJson(jsonSugar);

    blocTipoAcucar.sinkGenericBloc.add(sugarModel.tipoAcucares);
    blocProduto.sinkGenericBloc.add(sugarModel.produtos);
    blocUsina.sinkGenericBloc.add(sugarModel.usinas);
    blocTipoUsina.sinkGenericBloc.add(sugarModel.tipoUsinas
        .where((value) => value.nomeTipoUsina == 'Todas')
        .toList());
  }

  Future<Formulario> getFormularioSugar() async {
    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel login = await blocLogin.getUser();
    String jsonFormulario = await FileBloc.readData(
        tipo: file.FORMULARIO, nomeFile: login.idUsuario);
    Formulario formularioSugar = formularioFromJson(jsonFormulario);
    return formularioSugar;
  }

  salvarSincronizado({breakbulk, container, @required tipo}) async {
    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel login = await blocLogin.getUser();

    String bkp = await FileBloc.readData(
        tipo: situacao.SINCRONIZADO, nomeFile: login.idUsuario);

    final json = backupSugarFromJson(bkp);

    if (tipo == 1) {
      if (json.dadosBreakBulk == null) {
        json.dadosBreakBulk = [breakbulk];
      } else {
        json.dadosBreakBulk.add(breakbulk);
      }
      salvarBackupJson(jsonBkp: json);
    } else if (tipo == 2) {
      if (json.dadosContainer == null) {
        json.dadosContainer = [container];
      } else {
        json.dadosContainer.add(container);
      }
      salvarBackupJson(jsonBkp: json);
    }
  }

  void salvarFormularioSugar({@required formularioSugar}) async {
    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel login = await blocLogin.getUser();

    FileBloc.saveData(
        tipo: file.FORMULARIO,
        values: formularioSugar,
        nomeFile: login.idUsuario);
  }

  void salvarBackupJson({@required jsonBkp}) async {
    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel login = await blocLogin.getUser();

    FileBloc.saveData(
        tipo: situacao.SINCRONIZADO,
        values: jsonBkp,
        nomeFile: login.idUsuario);
  }

  criarFormBreakBulk() async {
    DadosBreakBulk dadosBreakBulk = DadosBreakBulk.padrao();
    BreakBulk breakBulk = BreakBulk.padrao();
    var uuid = Uuid();

    Formulario formularioSugar = await getFormularioSugar();
    final bloc =
        BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();

    breakBulk.uuid = uuid.v1();
    breakBulk.tipoOperacao = bloc.getTipoOperacao;
    sinkUUIDFormAtual.add(breakBulk.uuid);
    breakBulk.status = 'NOVO';
    breakBulk.nomeFormulario =
        'Breakbulk - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}';
    breakBulk.dadosbreakbulk = dadosBreakBulk;
    formularioSugar.breakBulk.add(breakBulk);
    //formularioSugar.breakBulk.clear();
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
  }

  criarFormContainer({@required nomeFormContainer}) async {
    DadosContainer dadosContainer = DadosContainer.padrao();
    ContModel.Container container = ContModel.Container.padrao();
    var uuid = Uuid();

    Formulario formularioSugar = await getFormularioSugar();
    sinkIdFormAtualSincronizado.add(3);
    container.uuid = uuid.v1();
    sinkUUIDFormAtual.add(container.uuid);
    container.status = 'NOVO';
    container.nomeFormulario = nomeFormContainer;
    container.dadoscontainer = dadosContainer;
    formularioSugar.container.add(container);
    // formularioSugar.container.clear();
    container.dadoscontainer.booking = nomeFormContainer;
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
    sinkFormularioInicial.add(formularioSugar);
  }

  BreakBulk lastRemovedBreakBulk;
  ContModel.Container lastRemovedContainer;
  int lastRemovedPositionBreakBulk;
  int lastRemovedPositionContainer;

  excluirFormBreakBulk(int index) async {
    Formulario formularioSugar = await getFormularioSugar();
    formularioSugar.breakBulk.removeAt(index);
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
//    sinkFormularioInicial.add(formularioSugar);
  }

  excluirFormContainer(int index) async {
    Formulario formularioSugar = await getFormularioSugar();
    formularioSugar.container.removeAt(index);
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
//    sinkFormularioInicial.add(formularioSugar);
  }

  salvarFormBreakBulk(bb) async {
    Formulario formularioSugar = await getFormularioSugar();
    formularioSugar.breakBulk.add(bb);
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
    sinkFormularioInicial.add(formularioSugar);
  }

  salvarFormContainer(c) async {
    Formulario formularioSugar = await getFormularioSugar();
    formularioSugar.container.add(c);
    salvarFormularioSugar(formularioSugar: formularioSugar);
    sinkLisInicial.add(formularioSugar);
    sinkFormularioInicial.add(formularioSugar);
  }

  Future<bool> sincronizarService(
      {@required formulario,
      @required tipo,
      @required status,
      @required tipoFormulario}) async {
    final LoginBloc blocLogin =
        BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();
    LoginModel login = await blocLogin.getUser();

    SugarService _sugarService = SugarService();

    var data = await _sugarService.sincronizarSugar(
        tipoFormulario: tipoFormulario,
        status: status,
        idUsuario: login.idUsuario,
        formulario: formulario);

    if (data != null && tipo == 1) {
      BackupBreakbulk bkpBreakbulk = BackupBreakbulk.fromJson(data);
      await salvarSincronizado(breakbulk: bkpBreakbulk, tipo: 1);
      return true;
    } else if (data != null && tipo == 2) {
      BackupContainer bkpContainer = BackupContainer.fromJson(data);
      await salvarSincronizado(container: bkpContainer, tipo: 2);
      return true;
    } else {
      return false;
    }
  }

  getCaminhoesVagoes() {
    final blocCaminhoesVagoes =
        BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

    getFormAtual.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == valueUUIDFormAtual) {
        blocCaminhoesVagoes.sinkListBreakBulkCaminhoesVagoes
            .add(dadosBreakBulk.dadosbreakbulk.caminhoesVagoesRegistrados);
      }
    });
  }

  Future<DadosBreakBulk> getDadosBreakBulk() async {
    DadosBreakBulk dado;
    final sugarBloc = BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

    getFormAtual.breakBulk.forEach((dados) {
      if (dados.uuid == valueUUIDFormAtual) {
        if (dados.dadosbreakbulk != null) {
          dado = dados.dadosbreakbulk;
        }
      }
    });
    if (dado != null) {
      if (dado.caminhoesVagoesRegistrados != null) {
        sugarBloc.sinkListBreakBulkCaminhoesVagoes
            .add(dado.caminhoesVagoesRegistrados);
      }
      if (dado.timeLogs != null) {
        sugarBloc.sinkListInicialTimeLogs.add(dado.timeLogs);
      }

      if (dado.embarquesRegistrados != null) {
        sugarBloc.sinkListInicialEmbarque.add(dado.embarquesRegistrados);
      }
      if (dado.recebimentosRegistrados != null) {
        sugarBloc.sinkListInicialRecebimento.add(dado.recebimentosRegistrados);
      }
    }
    return dado;
  }

  Future<DadosContainer> getDadosContainer() async {
    DadosContainer dado;
    final blocInspEstuDeso =
        BlocProvider.tag('container').getBloc<ContainerBloc>();
    await getFormulario();
    getFormAtual.container.forEach((dados) {
      if (dados.uuid == valueUUIDFormAtual) {
        if (dados.dadoscontainer != null) {
          dado = dados.dadoscontainer;
        }
        blocInspEstuDeso.sinkListInicialInspecaoEstufagemDesova
            .add(dados.dadoscontainer.containersRegistrados);
      }
    });

    if (dado != null) {
      if (dado.timeLogs != null) {
        blocInspEstuDeso.sinkListInicialTimeLogs.add(dado.timeLogs);
      }
      if (dado.quebraNotasFiscais != null) {
        blocInspEstuDeso.sinkListInicialQuebraDeNota
            .add(dado.quebraNotasFiscais);
      }
    }

    return dado;
  }

  getQuebraNota() {
    final blocQuebraNota =
        BlocProvider.tag('container').getBloc<ContainerBloc>();

    getFormAtual.container.forEach((dados) {
      if (dados.uuid == valueUUIDFormAtual) {
        blocQuebraNota.sinkListInicialQuebraDeNota
            .add(dados.dadoscontainer.quebraNotasFiscais);
      }
    });
  }

  getTimeLogs(tipo) {
    if (tipo == 1) {
      final blocTimeLogs =
          BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

      getFormAtual.breakBulk.forEach((dadosBreakBulk) {
        if (dadosBreakBulk.uuid == valueUUIDFormAtual) {
          blocTimeLogs.sinkListInicialTimeLogs
              .add(dadosBreakBulk.dadosbreakbulk.timeLogs);
        }
      });
    } else {
      final blocTimeLogs =
          BlocProvider.tag('container').getBloc<ContainerBloc>();
      getFormAtual.container.forEach((dadosContainer) {
        if (dadosContainer.uuid == valueUUIDFormAtual) {
          blocTimeLogs.sinkListInicialTimeLogs
              .add(dadosContainer.dadoscontainer.timeLogs);
        }
      });
    }
  }

  getEmbarque() {
    final blocEmbarque = BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

    getFormAtual.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == valueUUIDFormAtual) {
        blocEmbarque
          ..sinkListInicialEmbarque
              .add(dadosBreakBulk.dadosbreakbulk.embarquesRegistrados);
      }
    });
  }

  getRecebimento() {
    final blocRecebimento =
        BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

    getFormAtual.breakBulk.forEach((dadosBreakBulk) {
      if (dadosBreakBulk.uuid == valueUUIDFormAtual) {
        blocRecebimento
          ..sinkListInicialRecebimento
              .add(dadosBreakBulk.dadosbreakbulk.recebimentosRegistrados);
      }
    });
  }

  Future<void> getFormulario() async {
    Formulario form = await getFormularioSugar();
    sinkFormularioInicial.add(form);
    sinkLisInicial.add(form);
  }
}
