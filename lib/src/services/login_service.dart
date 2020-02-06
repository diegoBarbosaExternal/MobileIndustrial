import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/models/login_model.dart';
import 'package:sugar/src/ui/widgets/awasome_dialog.dart';
import 'package:sugar/src/utils/constants.dart';

class LoginService {
  Dio dio;
  AwasomeDialog awasome = AwasomeDialog();

  LoginService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
  }

  Future<LoginModel> getLogin(
      {@required login, @required senha, @required context}) async {
    Response response = await dio
        .post('/login', data: {"login": login, "senha": senha}).catchError((e) {
      if (e.response == null) {
        Navigator.pop(context);
        awasome.awasomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            title: 'Erro ao logar',
            text: Column(
              children: <Widget>[
                Center(child: Text(
                    'Ops...', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text(FlutterI18n.translate(context,
                    "msgValidacoesTelaLogin.msgUsuarioServidorAusente"),
                    style: TextStyle(fontWeight: FontWeight.bold)),)
              ],
            ),
            btnOkColor: Colors.red);
      } else {
        Navigator.pop(context);
        awasome.awasomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            title: 'Erro ao logar',
            text: Column(
              children: <Widget>[
                Center(child: Text(
                    'Ops...', style: TextStyle(fontWeight: FontWeight.bold))),
                Center(child: Text(FlutterI18n.translate(context,
                    "msgValidacoesTelaLogin.msgUsuarioErroDesconhecido"),
                    style: TextStyle(fontWeight: FontWeight.bold)),)
              ],
            ),
            btnOkColor: Colors.red);
      }
      return null;
    });

    if (response.data != null && response.data.toString().isNotEmpty) {
      return LoginModel.fromJson(response.data);
    } else {
      Navigator.pop(context);
      awasome.awasomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'Erro ao logar',
          text: Column(
            children: <Widget>[
              Center(child: Text(
                  'Ops...', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text(FlutterI18n.translate(
                  context, "msgValidacoesTelaLogin.msgUsuarioSenhaIncorretos"),
                  style: TextStyle(fontWeight: FontWeight.bold)),)
            ],
          ),
          btnOkColor: Colors.red);
      return null;
    }
  }
}
