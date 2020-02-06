// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sincronizar_breakbulk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SincronizarBreakbulk _$SincronizarBreakbulkFromJson(Map<String, dynamic> json) {
  return SincronizarBreakbulk(
    idUsuario: json['idUsuario'] as int,
    login: json['login'] as String,
    status: json['status'] as int,
    tipoFormulario: json['tipoFormulario'] as int,
    breakBulk: json['breakBulk'] == null
        ? null
        : BreakBulk.fromJson(json['breakBulk'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SincronizarBreakbulkToJson(
        SincronizarBreakbulk instance) =>
    <String, dynamic>{
      'idUsuario': instance.idUsuario,
      'login': instance.login,
      'status': instance.status,
      'tipoFormulario': instance.tipoFormulario,
      'breakBulk': instance.breakBulk,
    };
