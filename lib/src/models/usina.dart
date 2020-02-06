import 'package:json_annotation/json_annotation.dart';

part 'usina.g.dart';

@JsonSerializable()
class Usina {
  int idUsina;
  String usina;

  Usina(this.idUsina, this.usina);

  factory Usina.fromJson(Map<String, dynamic> json) => _$UsinaFromJson(json);

  bool operator == (Object other) =>
      other is Usina &&
          other.idUsina == idUsina &&
          other.usina == usina;

  Map<String, dynamic> toJson() => _$UsinaToJson(this);
}
