import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:sugar/src/utils/constants.dart';

class UsinaService{
  Dio dio;

  UsinaService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
  }

  Future<List<Usina>> getUsinas({@required login}) async {
    Response response = await dio.get('/usina/$login').catchError((e) {
      print('Erro ao trazer usinas. \n\n $e');
    });

    if (response.data != null && response.data.toString().isNotEmpty) {
      List<Usina> usinas = [];
      (response.data as List).forEach((usina){
        usinas.add(Usina.fromJson(usina));
      });
      return usinas;
    }else{
      return null;
    }
  }
}