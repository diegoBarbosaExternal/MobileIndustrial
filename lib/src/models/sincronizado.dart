import 'dart:convert';

import 'package:sugar/src/models/container.dart';
import 'package:sugar/src/models/sincronizar_breakbulk.dart';
import 'package:sugar/src/models/sincronizar_container.dart';

List<BackupBreakbulk> backupBreakbulkFromJson(String str) => List<BackupBreakbulk>.from(json.decode(str).map((x) => BackupBreakbulk.fromJson(x)));

String backupBreakbulkToJson(List<BackupBreakbulk> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BackupBreakbulk {
  int id;
  String dataCadastro;
  int idUsuario;
  int status;
  int tipoFormulario;
  SincronizarBreakbulk jsonSugar;

  BackupBreakbulk({
    this.id,
    this.dataCadastro,
    this.idUsuario,
    this.status,
    this.tipoFormulario,
    this.jsonSugar,
  });

  factory BackupBreakbulk.fromJson(Map<String, dynamic> json) => BackupBreakbulk(
    id: json["id"],
    dataCadastro: json["dataCadastro"],
    idUsuario: json["idUsuario"],
    status: json["status"],
    tipoFormulario: json["tipoFormulario"],
    jsonSugar: SincronizarBreakbulk.fromJson(json["jsonSugar"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dataCadastro": dataCadastro,
    "idUsuario": idUsuario,
    "status": status,
    "tipoFormulario": tipoFormulario,
    "jsonSugar": jsonSugar.toJson(),
  };
}

List<BackupContainer> backupContainerFromJson(String str) => List<BackupContainer>.from(json.decode(str).map((x) => BackupContainer.fromJson(x)));

String backupContainerToJson(List<BackupContainer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BackupContainer {
  int id;
  String dataCadastro;
  int idUsuario;
  int status;
  int tipoFormulario;
  SincronizarContainer jsonSugar;

  BackupContainer({
    this.id,
    this.dataCadastro,
    this.idUsuario,
    this.status,
    this.tipoFormulario,
    this.jsonSugar,
  });

  factory BackupContainer.fromJson(Map<String, dynamic> json) => BackupContainer(
    id: json["id"],
    dataCadastro: json["dataCadastro"],
    idUsuario: json["idUsuario"],
    status: json["status"],
    tipoFormulario: json["tipoFormulario"],
    jsonSugar: SincronizarContainer.fromJson(json["jsonSugar"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dataCadastro": dataCadastro,
    "idUsuario": idUsuario,
    "status": status,
    "tipoFormulario": tipoFormulario,
    "jsonSugar": jsonSugar.toJson(),
  };
}

BackupSugar backupSugarFromJson(String str) => BackupSugar.fromJson(json.decode(str));

String backupSugarToJson(BackupSugar data) => json.encode(data.toJson());

class BackupSugar {
  List<BackupBreakbulk> dadosBreakBulk;
  List<BackupContainer> dadosContainer;

  BackupSugar({
    this.dadosBreakBulk,
    this.dadosContainer,
  });

  factory BackupSugar.fromJson(Map<String, dynamic> json) => BackupSugar(
    dadosBreakBulk: List<BackupBreakbulk>.from(json["dadosBreakBulk"].map((x) => BackupBreakbulk.fromJson(x))),
    dadosContainer: List<BackupContainer>.from(json["dadosContainer"].map((x) => BackupContainer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dadosBreakBulk": List<dynamic>.from(dadosBreakBulk.map((x) => x.toJson())),
    "dadosContainer": List<dynamic>.from(dadosContainer.map((x) => x.toJson())),
  };
}