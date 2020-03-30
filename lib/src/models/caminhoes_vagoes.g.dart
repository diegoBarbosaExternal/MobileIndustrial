// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caminhoes_vagoes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaminhoesVagoes _$CaminhoesVagoesFromJson(Map<String, dynamic> json) {
  return CaminhoesVagoes(
    json['caminhoesVagoes'] as String,
    json['notaFiscal'] as String,
    json['placa'] as String,
    json['pesoNota'] as String,
    json['quantidade'] as String,
    json['molhada'] as bool,
    json['suja'] as bool,
    json['rasgada'] as bool,
    json['empedrada'] as bool,
    json['falta'] as int,
    json['sobra'] as int,
    json['totalUnidades'] as int,
    json['pesoTotalUnidades'] as int,
    json['observacao'] as String,
    json['resumo'] as String,
  );
}

Map<String, dynamic> _$CaminhoesVagoesToJson(CaminhoesVagoes instance) =>
    <String, dynamic>{
      'caminhoesVagoes': instance.caminhoesVagoes,
      'notaFiscal': instance.notaFiscal,
      'placa': instance.placa,
      'pesoNota': instance.pesoNota,
      'quantidade': instance.quantidade,
      'molhada': instance.molhada,
      'suja': instance.suja,
      'rasgada': instance.rasgada,
      'empedrada': instance.empedrada,
      'falta': instance.falta,
      'sobra': instance.sobra,
      'totalUnidades': instance.totalUnidades,
      'pesoTotalUnidades': instance.pesoTotalUnidades,
      'observacao': instance.observacao,
      'resumo': instance.resumo,
    };
