import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'produto.g.dart';

List<Produto> produtoFromJson(String str) =>
    List<Produto>.from(json.decode(str).map((x) => Produto.fromJson(x)));

String produtoToJson(List<Produto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Produto {
  @JsonKey(name: 'codigo')
  int idProduto;
  @JsonKey(name: 'descricao')
  String nomeProduto;

  Produto(this.idProduto, this.nomeProduto);

  int get hashCode => idProduto.hashCode;

  bool operator == (Object other) =>
      other is Produto &&
      other.idProduto == idProduto &&
      other.nomeProduto == nomeProduto;

  factory Produto.fromJson(Map<String, dynamic> json) =>
      _$ProdutoFromJson(json);

  Map<String, dynamic> toJson() => _$ProdutoToJson(this);
}
