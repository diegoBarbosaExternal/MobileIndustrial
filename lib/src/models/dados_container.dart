import 'package:sugar/src/models/inf_container.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/models/quebra_nota.dart';
import 'package:sugar/src/models/quebra_notas_fiscais.dart';
import 'package:sugar/src/models/time_logs.dart';
import 'package:sugar/src/models/usina.dart';

import 'package:json_annotation/json_annotation.dart';

part 'dados_container.g.dart';

@JsonSerializable()
class DadosContainer {
  //TAG : INSPEÇÃO / ESTUFAGEM / DESOVA
  bool inspecao;
  bool estufagem;
  bool desova;
  String matricula;
  String ordemServico;
  String clientePrincipal;
  String localTerminal;
  Produto produto;
  String booking;
  String navio;
  String identificacaoEquipamento;
  String numeroCertificado;
  String dataVerificacao;
  String descricaoEmbalagem;
  String planoAmostragem;
  String identificacaoDosVolumes;
  bool doubleCheck;
  String empresa;
  int lacreDasAmostras;
  String resumo;

  //usando para : TAG : INSPEÇÃO / ESTUFAGEM / DESOVA e TAG : QUEBRA DE NOTA
  List<InformacaoContainer> containersRegistrados;

//----------------------------------------

  //TAG : TIMELOGS
  List<TimeLogs> timeLogs;

//----------------------------------------

  //TAG : SUPERVISAO DE PESO

  Usina usinaSP;
  String marcaDaBalanca;
  String numeroDeSerie;
  String ultimaCalibracao;
  String numeroDoLacre;
  List<double> pesoSacas;
  double totalKg;
  int unidadesPesadas;
  double media;
  double taraDaUnidade;
  double mediaDoPesoLiquido;
  String companhia;
  String front;
  String back;
  String inkjet;

//----------------------------------------

  //TAG : QUEBRA DE NOTA
  List<QuebraNotasFiscais> quebraNotasFiscais;

//----------------------------------------
  //TAG : ASSIATURA DIGITAL
  String inspetorSgs;
  String terminal;

  DadosContainer.padrao();

  DadosContainer(this.inspecao, this.estufagem, this.desova,
      this.matricula, this.ordemServico, this.clientePrincipal,
      this.localTerminal, this.produto, this.booking, this.navio,
      this.identificacaoEquipamento, this.numeroCertificado,
      this.dataVerificacao, this.descricaoEmbalagem, this.planoAmostragem,
      this.identificacaoDosVolumes, this.doubleCheck, this.empresa,
      this.lacreDasAmostras, this.resumo, this.containersRegistrados,
      this.timeLogs, this.usinaSP, this.marcaDaBalanca, this.numeroDeSerie,
      this.ultimaCalibracao, this.numeroDoLacre, this.pesoSacas, this.totalKg,
      this.unidadesPesadas, this.media, this.taraDaUnidade,
      this.mediaDoPesoLiquido, this.companhia, this.front, this.back,
      this.inkjet, this.quebraNotasFiscais, this.inspetorSgs, this.terminal);

  factory DadosContainer.fromJson(Map<String, dynamic> json) =>
      _$DadosContainerFromJson(json);

  Map<String, dynamic> toJson() => _$DadosContainerToJson(this);
}
