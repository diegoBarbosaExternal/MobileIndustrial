// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embarque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Embarque _$EmbarqueFromJson(Map<String, dynamic> json) {
  return Embarque(
    (json['quantidadeTotalPeso'] as num)?.toDouble(),
    json['porto'] as String,
    json['destino'] as String,
    json['dataInicioPorto'] as String,
    json['dataTerminoPorto'] as String,
    json['inspetora'] as String,
    json['quantidadeSaca'] as String,
    (json['pesoMedioSaca'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$EmbarqueToJson(Embarque instance) => <String, dynamic>{
      'quantidadeTotalPeso': instance.quantidadeTotalPeso,
      'porto': instance.porto,
      'destino': instance.destino,
      'dataInicioPorto': instance.dataInicioPorto,
      'dataTerminoPorto': instance.dataTerminoPorto,
      'inspetora': instance.inspetora,
      'quantidadeSaca': instance.quantidadeSaca,
      'pesoMedioSaca': instance.pesoMedioSaca,
    };
