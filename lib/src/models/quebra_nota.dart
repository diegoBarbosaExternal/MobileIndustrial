import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quebra_nota.g.dart';

@JsonSerializable()
class QuebraNota {
  String notaFiscal;
  String placa;
  Usina usina;
  TipoAcucar tipoDeAcucar;
  double totalDeSacas;
  double totalPorContainer;
  String sobra;
  String avaria;
  String faltaCarga;
  String observacao;


  QuebraNota.padrao();

  QuebraNota(
      this.notaFiscal,
      this.placa,
      this.usina,
      this.tipoDeAcucar,
      this.totalDeSacas,
      this.totalPorContainer,
      this.sobra,
      this.avaria,
      this.faltaCarga,
      this.observacao);

  factory QuebraNota.fromJson(Map<String, dynamic> json) =>
      _$QuebraNotaFromJson(json);

  Map<String, dynamic> toJson() => _$QuebraNotaToJson(this);
}
