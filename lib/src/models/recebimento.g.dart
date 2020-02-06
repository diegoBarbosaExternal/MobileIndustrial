// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recebimento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recebimento _$RecebimentoFromJson(Map<String, dynamic> json) {
  return Recebimento(
    json['tipoUsina'] == null
        ? null
        : TipoUsina.fromJson(json['tipoUsina'] as Map<String, dynamic>),
    json['usina'] == null
        ? null
        : Usina.fromJson(json['usina'] as Map<String, dynamic>),
    json['analiseProduto'] as String,
    json['resultado'] as String,
    json['turno'] as String,
    json['numeroCaminhoesComposta'] as int,
  );
}

Map<String, dynamic> _$RecebimentoToJson(Recebimento instance) =>
    <String, dynamic>{
      'tipoUsina': instance.tipoUsina,
      'usina': instance.usina,
      'analiseProduto': instance.analiseProduto,
      'resultado': instance.resultado,
      'turno': instance.turno,
      'numeroCaminhoesComposta': instance.numeroCaminhoesComposta,
    };
