import 'package:json_annotation/json_annotation.dart';

part 'tipo_usina.g.dart';

@JsonSerializable()
class TipoUsina {
  @JsonKey(name: 'codigo')
  int idTipoUsina;
  @JsonKey(name: 'descricao')
  String nomeTipoUsina;

  TipoUsina(this.idTipoUsina, this.nomeTipoUsina);

  int get hashCode => idTipoUsina.hashCode;

  bool operator == (Object other) =>
      other is TipoUsina &&
      other.idTipoUsina == idTipoUsina &&
      other.nomeTipoUsina == nomeTipoUsina;

  factory TipoUsina.fromJson(Map<String, dynamic> json) =>
      _$TipoUsinaFromJson(json);

  Map<String, dynamic> toJson() => _$TipoUsinaToJson(this);
}
