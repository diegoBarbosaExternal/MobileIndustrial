// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produto _$ProdutoFromJson(Map<String, dynamic> json) {
  return Produto(
    json['codigo'] as int,
    json['descricao'] as String,
  );
}

Map<String, dynamic> _$ProdutoToJson(Produto instance) => <String, dynamic>{
      'codigo': instance.idProduto,
      'descricao': instance.nomeProduto,
    };
