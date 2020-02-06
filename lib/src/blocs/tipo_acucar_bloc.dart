import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/services/tipo_acucar_service.dart';

class TipoAcucarBloc implements BlocBase {
  final _genericDrop = BehaviorSubject<List<TipoAcucar>>();
  final _tipoAcucarQuebraDeNota = BehaviorSubject<List<TipoAcucar>>();

  StreamSubscription tipoAcucar;

  Stream<List<TipoAcucar>> get outGenericBloc => _genericDrop.stream;

  Sink<List<TipoAcucar>> get sinkGenericBloc => _genericDrop.sink;

  Stream<List<TipoAcucar>> get outSuperEmbReceb =>
      _tipoAcucarQuebraDeNota.stream;

  Sink<List<TipoAcucar>> get sinkSuperEmbReceb => _tipoAcucarQuebraDeNota.sink;

  List<TipoAcucar> get tipoAcucares => _genericDrop.stream.value;

  TipoAcucar valueTipoAcucarQuebraDeNota;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _tipoAcucarQuebraDeNota.close();
    tipoAcucar.cancel();
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

  Future<List<TipoAcucar>> tipoAcucarService() async {
    TipoAcucarService _tipoAcucarService = TipoAcucarService();
    List<TipoAcucar> tipoAcucares = [];

    tipoAcucares = await _tipoAcucarService.getTipoAcucar();
    return tipoAcucares;
  }
}
