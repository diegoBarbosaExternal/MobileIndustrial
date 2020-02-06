import 'package:sugar/src/models/dados_breakbulk.dart';
import 'package:json_annotation/json_annotation.dart';

part 'breakbulk.g.dart';

@JsonSerializable()
class BreakBulk {
  String nomeFormulario;
  String uuid;
  String status;
  DadosBreakBulk dadosbreakbulk;
  int tipoOperacao;

  BreakBulk(this.uuid, this.status, this.nomeFormulario, this.dadosbreakbulk,
      this.tipoOperacao);

  BreakBulk.padrao();

  factory BreakBulk.fromJson(Map<String, dynamic> json) =>
      _$BreakBulkFromJson(json);

  Map<String, dynamic> toJson() => _$BreakBulkToJson(this);
}
