// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_usina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipoUsina _$TipoUsinaFromJson(Map<String, dynamic> json) {
  return TipoUsina(
    json['codigo'] as int,
    json['descricao'] as String,
  );
}

Map<String, dynamic> _$TipoUsinaToJson(TipoUsina instance) => <String, dynamic>{
      'codigo': instance.idTipoUsina,
      'descricao': instance.nomeTipoUsina,
    };
