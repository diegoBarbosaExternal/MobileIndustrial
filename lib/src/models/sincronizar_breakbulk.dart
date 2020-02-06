import 'package:sugar/src/models/breakbulk.dart';

import 'package:json_annotation/json_annotation.dart';

part 'sincronizar_breakbulk.g.dart';

@JsonSerializable()
class SincronizarBreakbulk {
  int idUsuario;
  String login;
  int status;
  int tipoFormulario;
  BreakBulk breakBulk;

  SincronizarBreakbulk.padrao();

  SincronizarBreakbulk(
      {this.idUsuario,
      this.login,
      this.status,
      this.tipoFormulario,
      this.breakBulk});

  factory SincronizarBreakbulk.fromJson(Map<String, dynamic> json) =>
      _$SincronizarBreakbulkFromJson(json);

  Map<String, dynamic> toJson() => _$SincronizarBreakbulkToJson(this);
}
