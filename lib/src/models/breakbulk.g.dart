// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakbulk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreakBulk _$BreakBulkFromJson(Map<String, dynamic> json) {
  return BreakBulk(
    json['uuid'] as String,
    json['status'] as String,
    json['nomeFormulario'] as String,
    json['dadosbreakbulk'] == null
        ? null
        : DadosBreakBulk.fromJson(
            json['dadosbreakbulk'] as Map<String, dynamic>),
    json['tipoOperacao'] as int,
  );
}

Map<String, dynamic> _$BreakBulkToJson(BreakBulk instance) => <String, dynamic>{
      'nomeFormulario': instance.nomeFormulario,
      'uuid': instance.uuid,
      'status': instance.status,
      'dadosbreakbulk': instance.dadosbreakbulk,
      'tipoOperacao': instance.tipoOperacao,
    };
