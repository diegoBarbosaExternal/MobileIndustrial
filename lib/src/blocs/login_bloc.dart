import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/file_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/container.dart' as ContainerModel;
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/login_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:sugar/src/models/sincronizado.dart';
import 'package:sugar/src/models/sugar_model.dart';
import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/services/login_service.dart';
import 'package:sugar/src/ui/widgets/awasome_dialog.dart';

class LoginBloc implements BlocBase {
  final CHAVE = '4Rtv9UH56xWtAyNcS5Yr3jrPmWs26Wa6';
  final LENGHT_VETOR = 16;
  StreamSubscription usuario;

  var _autoValidateController = BehaviorSubject<bool>.seeded(false);
  var _loginDataController = BehaviorSubject<LoginModel>();

  Stream<bool> get outAutoValidate => _autoValidateController.stream;

  Sink<bool> get inAutoValidate => _autoValidateController.sink;

  Stream<LoginModel> get outLoginData => _loginDataController.stream;

  Sink<LoginModel> get inLoginData => _loginDataController.sink;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    usuario.cancel();
    _loginDataController.close();
    _autoValidateController.close();
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

  Future<bool> login(
      {@required String login,
      @required String senha,
      @required BuildContext context}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      LoginService _loginService = LoginService();

      File fileLogin = await FileBloc.getFile(tipo: file.LOGIN);
      bool existFileLogin = await fileLogin.exists();

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        LoginModel dataUser;

        dataUser = await _loginService.getLogin(
            login: login, senha: senha, context: context);

        if (dataUser != null) {
          inLoginData.add(dataUser);

          if (existFileLogin) {
            String jsonLogin =
                await FileBloc.readData(tipo: file.LOGIN, nomeFile: null);
            List<LoginModel> logins = loginModelFromJson(jsonLogin);
            int index = 0;
            logins.forEach((user) {
              if (dataUser.idUsuario == user.idUsuario) {
                user.login = dataUser.login;
                user.nome = dataUser.nome;
                user.senha = encrypt(senha);
              } else {
                index++;
              }
            });

            if (index == logins.length) {
              dataUser.senha = encrypt(senha);
              logins.add(dataUser);
            }
            FileBloc.saveData(tipo: file.LOGIN, values: logins, nomeFile: null);
          } else {
            dataUser.senha = encrypt(senha);
            FileBloc.saveData(
                tipo: file.LOGIN, values: [dataUser], nomeFile: null);
          }
          //SUGAR
          ProdutoBloc produtoBloc = ProdutoBloc();
          TipoAcucarBloc tipoAcucarBloc = TipoAcucarBloc();
          UsinaBloc usinaBloc = UsinaBloc();
          TipoUsinaBloc tipoUsinaBloc = TipoUsinaBloc();
          SugarModel sugarModel = SugarModel();

          sugarModel.idUsuario = dataUser.idUsuario;
          sugarModel.login = dataUser.login;

          sugarModel.tipoAcucares = await tipoAcucarBloc.tipoAcucarService();
          sugarModel.produtos = await produtoBloc.produtosService();

          sugarModel.usinas =
              await usinaBloc.usinasService(login: dataUser.login);

          sugarModel.tipoUsinas =
              await tipoUsinaBloc.tipoUsinasService(idUser: dataUser.idUsuario);

          FileBloc.saveData(
              tipo: file.SUGAR,
              values: sugarModel,
              nomeFile: dataUser.idUsuario);

          //FORMULARIO
          File fileFormulario = await FileBloc.getFile(
              tipo: file.FORMULARIO, nomeFile: dataUser.idUsuario);
          bool existFileFormulario = await fileFormulario.exists();

          if (!existFileFormulario) {
            List<BreakBulk> breakBulks = [];
            List<ContainerModel.Container> containers = [];

            Formulario formulario = Formulario(
                idUsuario: dataUser.idUsuario,
                login: dataUser.login,
                breakBulk: breakBulks,
                container: containers);

            FileBloc.saveData(
                tipo: file.FORMULARIO,
                values: formulario,
                nomeFile: dataUser.idUsuario);

            List<BackupBreakbulk> dadosBreakbulk = [];
            List<BackupContainer> dadosContainer = [];
            BackupSugar bkpSugar = BackupSugar(
                dadosBreakBulk: dadosBreakbulk, dadosContainer: dadosContainer);

            FileBloc.saveData(
                tipo: situacao.SINCRONIZADO,
                values: bkpSugar,
                nomeFile: dataUser.idUsuario);
          }
          return true;
        } else {
          return false;
        }
      } else {
        Navigator.pop(context);
        AwasomeDialog awasome = AwasomeDialog();
        if (existFileLogin) {
          String jsonLogin =
              await FileBloc.readData(tipo: file.LOGIN, nomeFile: null);
          List<LoginModel> userLocal = loginModelFromJson(jsonLogin);
          bool autenticado = false;
          userLocal.forEach((user) {
            if (user.login == login) {
              String senhaCrypt = encrypt(senha);
              if (senhaCrypt == user.senha) {
                inLoginData.add(user);
                autenticado = true;
              }
            }
          });

          if (autenticado) {
            return true;
          } else {
            awasome.awasomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'Sem conexão',
                text: Column(
                  children: <Widget>[
                    Center(
                      child: Text("Ops...",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Text(
                          FlutterI18n.translate(
                              context, "msgValidacoesTelaLogin.msgSemConexao"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                btnOkColor: Colors.red);
            return false;
          }
        } else {
          awasome.awasomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'Sem conexão',
              text: Column(
                children: <Widget>[
                  Center(
                    child: Text("Ops...",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Center(
                    child: Text(
                        FlutterI18n.translate(
                            context, "msgValidacoesTelaLogin.msgSemConexao"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              btnOkColor: Colors.red);
          return false;
        }
      }
    } catch (e) {
      if (e.message != null) {
        print(e);
      }
      return false;
    }
  }

  String encrypt(senha) {
    final encrypter = Encrypter(AES(Encrypt.Key.fromUtf8(CHAVE)));
    final senhaEncrypted =
        encrypter.encrypt(senha, iv: IV.fromLength(LENGHT_VETOR));
    return senhaEncrypted.base64;
  }

  String decrypt(senhaEncrypted) {
    final encrypter = Encrypter(AES(Encrypt.Key.fromUtf8(CHAVE)));
    final decrypted =
        encrypter.decrypt64(senhaEncrypted, iv: IV.fromLength(LENGHT_VETOR));
    return decrypted;
  }

  Future<LoginModel> getUser() async {
    LoginModel user = LoginModel();
    usuario = await _loginDataController.stream.listen((login) {
      user = login;
    });
    return user;
  }
}
