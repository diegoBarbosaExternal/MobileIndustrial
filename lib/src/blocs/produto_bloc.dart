import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/services/produto_service.dart';

class ProdutoBloc implements BlocBase {
  final _genericDrop = BehaviorSubject<List<Produto>>();
  final _produtoSuperEmbReceb = BehaviorSubject<List<Produto>>();
  final _produtoInspEstuDesova = BehaviorSubject<List<Produto>>();
  StreamSubscription produto;

  Stream<List<Produto>> get outGenericBloc => _genericDrop.stream;

  Sink<List<Produto>> get sinkGenericBloc => _genericDrop.sink;

  Stream<List<Produto>> get outSuperEmbReceb => _produtoSuperEmbReceb.stream;

  Sink<List<Produto>> get sinkSuperEmbReceb => _produtoSuperEmbReceb.sink;

  Stream<List<Produto>> get outInspEstuDesova => _produtoInspEstuDesova.stream;

  Sink<List<Produto>> get sinkInspEstuDesova => _produtoInspEstuDesova.sink;

  List<Produto> get produtos => _genericDrop.stream.value;

  Produto valueProdutSuperEmbReceb;
  Produto valueProdutoInspEstuDesova;


  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    produto.cancel();
    _genericDrop.close();
    _produtoSuperEmbReceb.close();
    _produtoInspEstuDesova.close();
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

  Future<List<Produto>> produtosService() async {
    ProdutoService _produtoService = ProdutoService();
    List<Produto> produtos = [];

    produtos = await _produtoService.getProdutos();
    return produtos;
  }

}
