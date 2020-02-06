import 'package:dio/dio.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/utils/constants.dart';

class ProdutoService {
  Dio dio;

  ProdutoService() {
    dio = Dio();
    dio.options.baseUrl = BASE_URL;
  }

  Future<List<Produto>> getProdutos() async {
    Response response = await dio.get('/produto').catchError((e) {
      print('Erro ao trazer produto. \n\n $e');
    });

    if (response.data != null && response.data.toString().isNotEmpty) {
      List<Produto> produtos = [];
      (response.data as List).forEach((produto){
        produtos.add(Produto.fromJson(produto));
      });
      return produtos;
    }else{
      return null;
    }
  }
}
