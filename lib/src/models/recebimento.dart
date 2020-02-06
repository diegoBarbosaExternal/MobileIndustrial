import 'package:sugar/src/models/tipo_usina.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:sugar/src/models/usina.dart';

part 'recebimento.g.dart';

@JsonSerializable()
class Recebimento {
  TipoUsina tipoUsina;
  Usina usina;
  String analiseProduto;
  String resultado;
  String turno;
  int numeroCaminhoesComposta;

  Recebimento(this.tipoUsina, this.usina, this.analiseProduto, this.resultado,
      this.turno, this.numeroCaminhoesComposta);

  Recebimento.padrao();

  factory Recebimento.fromJson(Map<String, dynamic> json) =>
      _$RecebimentoFromJson(json);

  Map<String, dynamic> toJson() => _$RecebimentoToJson(this);
}
