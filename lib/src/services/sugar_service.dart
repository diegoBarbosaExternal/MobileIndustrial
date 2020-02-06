import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sugar/src/utils/constants.dart';

class SugarService {
  Dio dio;

  SugarService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
    dio.options.receiveTimeout = 60000;
  }

  Future<dynamic> sincronizarSugar(
      {@required idUsuario,
      @required status,
      @required tipoFormulario,
      @required formulario}) async {
    Response response = await dio.post('/sugar', data: {
      "idUsuario": idUsuario,
      "status": status,
      "tipoFormulario": tipoFormulario,
      "json": formulario
    }).catchError((e) {
      print('Erro ao sincronizar  \n\n $e');
    });

    if (response != null &&
        response.data != null &&
        response.data.toString().isNotEmpty) {
      return response.data;
    } else {
      return null;
    }
  }
}
