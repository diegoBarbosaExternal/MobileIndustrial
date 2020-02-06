import 'package:sugar/src/models/caminhoes_vagoes.dart';
import 'package:sugar/src/models/embarque.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/models/recebimento.dart';
import 'package:sugar/src/models/time_logs.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dados_breakbulk.g.dart';

@JsonSerializable()
class DadosBreakBulk {


  //TAG : SUPERVISAO / EMABRQUE / RECEBIMENTO
  String ordemDeServico;
  String clientePrincipal;
  String localTerminal;
  Produto produto;
  String navio;
  String origem;

  //----------------------------------------
  //TAG : CAMINHOES VAGOES

  List<CaminhoesVagoes> caminhoesVagoesRegistrados;
  String resumo;

//----------------------------------------
  //TAG : TIMELOGS
  List<TimeLogs> timeLogs;

//----------------------------------------
  //TAG : EMBARQUE

  List<Embarque> embarquesRegistrados;

//----------------------------------------
  // TAG : RECEBIMENTO
  List<Recebimento> recebimentosRegistrados;

//----------------------------------------
  //TAG : ASSINATURA DIGITAL
  String inspetorSgs;
  String terminal;

  DadosBreakBulk(this.ordemDeServico, this.clientePrincipal, this.localTerminal,
      this.produto, this.navio, this.origem, this.caminhoesVagoesRegistrados,
      this.resumo, this.timeLogs, this.embarquesRegistrados,
      this.recebimentosRegistrados, this.inspetorSgs, this.terminal);

  DadosBreakBulk.padrao();

  factory DadosBreakBulk.fromJson(Map<String, dynamic> json) =>
      _$DadosBreakBulkFromJson(json);

  Map<String, dynamic> toJson() => _$DadosBreakBulkToJson(this);
}
