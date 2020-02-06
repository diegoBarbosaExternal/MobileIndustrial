import 'package:dio/dio.dart';
import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/utils/constants.dart';

class TipoAcucarService {
  Dio dio;

  TipoAcucarService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
  }

  Future<List<TipoAcucar>> getTipoAcucar() async {
    Response response = await dio.get('/produto').catchError((e) {
      print('Erro ao trazer tipo açucar. \n\n $e');
    });

    if (response.data != null && response.data.toString().isNotEmpty) {
      List<TipoAcucar> tipoAcucares = [];
      (response.data as List).forEach((tipoAcucar) {
        tipoAcucares.add(TipoAcucar.fromJson(tipoAcucar));
      });
      return tipoAcucares;
    } else {
      return null;
    }
  }
}
