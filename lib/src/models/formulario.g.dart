// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Formulario _$FormularioFromJson(Map<String, dynamic> json) {
  return Formulario(
    idUsuario: json['idUsuario'] as int,
    login: json['login'] as String,
    breakBulk: (json['breakBulk'] as List)
        ?.map((e) =>
            e == null ? null : BreakBulk.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    container: (json['container'] as List)
        ?.map((e) =>
            e == null ? null : Container.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FormularioToJson(Formulario instance) =>
    <String, dynamic>{
      'idUsuario': instance.idUsuario,
      'login': instance.login,
      'breakBulk': instance.breakBulk,
      'container': instance.container,
    };
