import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class TipoFormularioBloc extends BlocBase {
  final _tipoFormularioBloc = BehaviorSubject<int>();
  final _tipoOperacaoBreakBulk = BehaviorSubject<int>();

  Stream<int> get outTipoFomulario => _tipoFormularioBloc.stream;
  Sink get sinkTipoformulario => _tipoFormularioBloc.sink;

  Stream<int> get outTipoOperacaoBreakBulk => _tipoOperacaoBreakBulk.stream;
  Sink get sinkTipoOperacaoBreakBulk => _tipoOperacaoBreakBulk.sink;

  int get getTipoOperacao => _tipoOperacaoBreakBulk.stream.value;

  final _isProgress = BehaviorSubject<bool>();

  Stream<bool> get outIsProgress => _isProgress.stream;
  Sink get sinkIsProgress => _isProgress.sink;

  int valorArmazenado;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _tipoOperacaoBreakBulk.close();
    _isProgress.close();
    _tipoFormularioBloc.close();
  }

  int getTipo() {
    valorArmazenado = _tipoFormularioBloc.value;
    return valorArmazenado;
  }



}
