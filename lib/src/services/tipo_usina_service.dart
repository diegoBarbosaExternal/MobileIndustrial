import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sugar/src/models/tipo_usina.dart';
import 'package:sugar/src/utils/constants.dart';

class TipoUsinaService{
  Dio dio;

  TipoUsinaService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
  }

  Future<List<TipoUsina>> getTipoUsinas({@required idUser}) async {
    Response response = await dio.get('/tipoUsina/$idUser').catchError((e) {
      print('Erro ao trazer tipo usinas. \n\n $e');
    });

    if (response.data != null && response.data.toString().isNotEmpty) {
      List<TipoUsina> tipoUsinas = [];
      (response.data as List).forEach((tipoUsina){
        tipoUsinas.add(TipoUsina.fromJson(tipoUsina));
      });
      return tipoUsinas;
    }else{
      return null;
    }
  }
}