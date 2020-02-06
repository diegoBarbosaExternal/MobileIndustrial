// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_acucar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipoAcucar _$TipoAcucarFromJson(Map<String, dynamic> json) {
  return TipoAcucar(
    json['codigo'] as int,
    json['descricao'] as String,
  );
}

Map<String, dynamic> _$TipoAcucarToJson(TipoAcucar instance) =>
    <String, dynamic>{
      'codigo': instance.idTipoAcucar,
      'descricao': instance.nomeTipoAcucar,
    };
