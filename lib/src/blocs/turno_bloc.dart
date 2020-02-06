import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class DropDowBlocTurno implements BlocBase {
  final _genericDrop = BehaviorSubject<String>.seeded(null);

  Stream<String> get outGenericBloc => _genericDrop.stream;

  Sink<String> get sinkGenericBloc => _genericDrop.sink;

  String valueTurno;

  List<String> getTurnos() {
    List<String> _usinas = ["MATUTINO", "VESPERTINO", "NOTURNO"];

    return _usinas;
  }

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


}
