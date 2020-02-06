import 'dart:convert';

import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/container.dart';

import 'package:json_annotation/json_annotation.dart';

part 'formulario.g.dart';

Formulario formularioFromJson(String str) => Formulario.fromJson(json.decode(str));

String formularioToJson(Formulario data) => json.encode(data.toJson());

@JsonSerializable()
class Formulario {

  int idUsuario;
  String login;
  List<BreakBulk> breakBulk;
  List<Container> container;

  Formulario.padrao();

  Formulario({this.idUsuario, this.login, this.breakBulk, this.container});


  factory Formulario.fromJson(Map<String, dynamic> json) =>
      _$FormularioFromJson(json);

  Map<String, dynamic> toJson() => _$FormularioToJson(this);


}
