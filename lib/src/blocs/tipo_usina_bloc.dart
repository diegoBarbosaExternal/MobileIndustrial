import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:sugar/src/models/tipo_usina.dart';
import 'package:sugar/src/services/tipo_usina_service.dart';

class TipoUsinaBloc implements BlocBase {
  final _genericDrop = BehaviorSubject<List<TipoUsina>>.seeded(null);

  Stream<List<TipoUsina>> get outGenericBloc => _genericDrop.stream;

  Sink<List<TipoUsina>> get sinkGenericBloc => _genericDrop.sink;

  List<TipoUsina> get tipoUsinas => _genericDrop.stream.value;

  TipoUsina valueTipoUsina;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
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

  Future<List<TipoUsina>> tipoUsinasService({@required idUser}) async {
    TipoUsinaService _tipoUsinaService = TipoUsinaService();
    List<TipoUsina> tipoUsinas = [];

    tipoUsinas = await _tipoUsinaService.getTipoUsinas(idUser: idUser);
    return tipoUsinas;
  }
}
