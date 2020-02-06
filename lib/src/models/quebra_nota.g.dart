// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quebra_nota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuebraNota _$QuebraNotaFromJson(Map<String, dynamic> json) {
  return QuebraNota(
    json['notaFiscal'] as String,
    json['placa'] as String,
    json['usina'] == null
        ? null
        : Usina.fromJson(json['usina'] as Map<String, dynamic>),
    json['tipoDeAcucar'] == null
        ? null
        : TipoAcucar.fromJson(json['tipoDeAcucar'] as Map<String, dynamic>),
    (json['totalDeSacas'] as num)?.toDouble(),
    (json['totalPorContainer'] as num)?.toDouble(),
    json['sobra'] as String,
    json['avaria'] as String,
    json['faltaCarga'] as String,
    json['observacao'] as String,
  );
}

Map<String, dynamic> _$QuebraNotaToJson(QuebraNota instance) =>
    <String, dynamic>{
      'notaFiscal': instance.notaFiscal,
      'placa': instance.placa,
      'usina': instance.usina,
      'tipoDeAcucar': instance.tipoDeAcucar,
      'totalDeSacas': instance.totalDeSacas,
      'totalPorContainer': instance.totalPorContainer,
      'sobra': instance.sobra,
      'avaria': instance.avaria,
      'faltaCarga': instance.faltaCarga,
      'observacao': instance.observacao,
    };
