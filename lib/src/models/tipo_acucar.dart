import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tipo_acucar.g.dart';

List<TipoAcucar> tipoAcucarFromJson(String str) =>
    List<TipoAcucar>.from(json.decode(str).map((x) => TipoAcucar.fromJson(x)));

String tipoAcucarToJson(List<TipoAcucar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TipoAcucar {
  @JsonKey(name: 'codigo')
  int idTipoAcucar;
  @JsonKey(name: 'descricao')
  String nomeTipoAcucar;

  TipoAcucar(this.idTipoAcucar, this.nomeTipoAcucar);

  int get hashCode => idTipoAcucar.hashCode;

  bool operator ==(Object other) =>
      other is TipoAcucar &&
      other.idTipoAcucar == idTipoAcucar &&
      other.nomeTipoAcucar == nomeTipoAcucar;

  factory TipoAcucar.fromJson(Map<String, dynamic> json) =>
      _$TipoAcucarFromJson(json);

  Map<String, dynamic> toJson() => _$TipoAcucarToJson(this);
}
