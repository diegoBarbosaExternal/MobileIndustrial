import 'package:json_annotation/json_annotation.dart';

part 'inf_container.g.dart';

@JsonSerializable()
class InformacaoContainer {
  String numeroContainer;
  double tara;
  int capacidade;
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
