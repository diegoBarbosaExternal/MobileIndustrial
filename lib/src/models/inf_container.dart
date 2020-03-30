import 'package:json_annotation/json_annotation.dart';

part 'inf_container.g.dart';

@JsonSerializable()
class InformacaoContainer {
  bool inspecao;
  bool estufagem;
  bool desova;
  String dataHoraInicioInspecao;
  String dataHoraFimInspecao;
  String numeroContainer;
  double tara;
  int capacidade;
  String produto;
  String dataFabricacao;
  bool condicao;
  String razaoRejeicao;
  String temperatura;
  int lacreSgs7Metros;
  int lacreDefinitivo;
  String lacreAgencia;
  int lacreOutros;
  String lote;
  String data;
  List<int> controleDeQuantidade;
  int total;

  InformacaoContainer.padrao();

  InformacaoContainer(
      this.inspecao,
      this.estufagem,
      this.desova,
      this.dataHoraInicioInspecao,
      this.dataHoraFimInspecao,
      this.numeroContainer,
      this.tara,
      this.capacidade,
      this.dataFabricacao,
      this.condicao,
      this.razaoRejeicao,
      this.temperatura,
      this.lacreSgs7Metros,
      this.lacreDefinitivo,
      this.lacreAgencia,
      this.lacreOutros,
      this.lote,
      this.data,
      this.controleDeQuantidade,
      this.total);

  factory InformacaoContainer.fromJson(Map<String, dynamic> json) =>
      _$InformacaoContainerFromJson(json);

  Map<String, dynamic> toJson() => _$InformacaoContainerToJson(this);
}
