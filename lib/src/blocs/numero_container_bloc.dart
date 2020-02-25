import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class DropDowBlocNumeroDoContainer implements BlocBase {
  final _genericDrop = BehaviorSubject<String>.seeded(null);
  final _listNumeroDosContainers = BehaviorSubject<List<String>>.seeded([]);

  Stream<String> get outGenericBloc => _genericDrop.stream;

  Sink<String> get sinkGenericBloc => _genericDrop.sink;

  Stream<List<String>> get outListNumeroDosContainers =>
      _listNumeroDosContainers.stream;

  Stream<List<String>> get outListNumeroDosContainersDistinct =>
      _listNumeroDosContainers.stream.distinctUnique();

  Sink<List<String>> get sinkListNumeroDosContainers =>
      _listNumeroDosContainers.sink;

  List<String> get valueListNumeroDosContainers =>
      _listNumeroDosContainers.stream.value;



  List<String> get listValueContainer => _listNumeroDosContainers.stream.value;


  String valueNumeroContainer;

  getListNumeroDoContainer(String numContainer) {
    listValueContainer.add(numContainer);
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _genericDrop.close();
    _listNumeroDosContainers.close();
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
