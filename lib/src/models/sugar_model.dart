import 'dart:convert';

import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/models/tipo_usina.dart';
import 'package:sugar/src/models/usina.dart';

SugarModel sugarModelFromJson(String str) => SugarModel.fromJson(json.decode(str));

String sugarModelToJson(SugarModel data) => json.encode(data.toJson());

class SugarModel {
  int idUsuario;
  String login;
  List<Produto> produtos;
  List<TipoAcucar> tipoAcucares;
  List<Usina> usinas;
  List<TipoUsina> tipoUsinas;

  SugarModel({
    this.idUsuario,
    this.login,
    this.tipoAcucares,
    this.produtos,
    this.usinas,
    this.tipoUsinas,
  });

  factory SugarModel.fromJson(Map<String, dynamic> json) => SugarModel(
    idUsuario: json["idUsuario"],
    login: json["login"],
    tipoAcucares: List<TipoAcucar>.from(
        json["tipoAcucares"].map((x) => TipoAcucar.fromJson(x))),
    produtos: List<Produto>.from(json["produtos"].map((x) => Produto.fromJson(x))),
    usinas: List<Usina>.from(json["usinas"].map((x) => Usina.fromJson(x))),
    tipoUsinas: List<TipoUsina>.from(json["tipoUsinas"].map((x) => TipoUsina.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "login": login,
    "tipoAcucares": List<dynamic>.from(tipoAcucares.map((x) => x.toJson())),
    "produtos": List<dynamic>.from(produtos.map((x) => x.toJson())),
    "usinas": List<dynamic>.from(usinas.map((x) => x.toJson())),
    "tipoUsinas": List<dynamic>.from(tipoUsinas.map((x) => x.toJson())),
  };
}