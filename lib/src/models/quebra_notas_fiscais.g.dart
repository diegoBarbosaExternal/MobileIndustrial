// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quebra_notas_fiscais.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuebraNotasFiscais _$QuebraNotasFiscaisFromJson(Map<String, dynamic> json) {
  return QuebraNotasFiscais(
    json['container'] as String,
    (json['quebraNotas'] as List)
        ?.map((e) =>
            e == null ? null : QuebraNota.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QuebraNotasFiscaisToJson(QuebraNotasFiscais instance) =>
    <String, dynamic>{
      'container': instance.container,
      'quebraNotas': instance.quebraNotas,
    };
