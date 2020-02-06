import 'package:json_annotation/json_annotation.dart';

part 'embarque.g.dart';

@JsonSerializable()
class Embarque {
  double quantidadeTotalPeso;
  String porto;
  String destino;
  String dataInicioPorto;
  String dataTerminoPorto;
  String inspetora;
  String quantidadeSaca;
  double pesoMedioSaca;

  Embarque(
      this.quantidadeTotalPeso,
      this.porto,
      this.destino,
      this.dataInicioPorto,
      this.dataTerminoPorto,
      this.inspetora,
      this.quantidadeSaca,
      this.pesoMedioSaca);

  Embarque.padrao();

  factory Embarque.fromJson(Map<String, dynamic> json) =>
      _$EmbarqueFromJson(json);

  Map<String, dynamic> toJson() => _$EmbarqueToJson(this);
}
