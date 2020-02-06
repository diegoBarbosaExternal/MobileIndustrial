import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:sugar/src/services/usina_service.dart';

class UsinaBloc implements BlocBase {
  final _quebraNotaDrop = BehaviorSubject<List<Usina>>();
  final _recebimentoDrop = BehaviorSubject<List<Usina>>();
  final _supervisaoPesoDrop = BehaviorSubject<List<Usina>>();
  final _genericDrop = BehaviorSubject<List<Usina>>();

  Stream<List<Usina>> get outGenericBloc => _genericDrop.stream;

  Sink<List<Usina>> get sinkGenericBloc => _genericDrop.sink;

  Stream<List<Usina>> get outQuebraNotaBloc => _quebraNotaDrop.stream;

  Sink<List<Usina>> get sinkQuebraNotaBloc => _quebraNotaDrop.sink;

  Stream<List<Usina>> get outRecebimentoBloc => _recebimentoDrop.stream;

  Sink<List<Usina>> get sinkRecebimentoBloc => _recebimentoDrop.sink;

  Stream<List<Usina>> get outsupervisaoPesoBloc => _supervisaoPesoDrop.stream;

  Sink<List<Usina>> get sinksupervisaoPesoBloc => _supervisaoPesoDrop.sink;

  List<Usina> get usinas => _genericDrop.stream.value;

  Usina valueQuebraNota;
  Usina valueSupervisaoPeso;
  Usina valueRecebimento;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _quebraNotaDrop.close();
    _recebimentoDrop.close();
    _supervisaoPesoDrop.close();
    _genericDrop.close();
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

  Future<List<Usina>> usinasService({@required login}) async {
    UsinaService _usinaService = UsinaService();
    List<Usina> usinas = [];

    usinas = await _usinaService.getUsinas(login: login);
    return usinas;
  }
}
