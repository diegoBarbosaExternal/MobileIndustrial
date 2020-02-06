// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sincronizar_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SincronizarContainer _$SincronizarContainerFromJson(Map<String, dynamic> json) {
  return SincronizarContainer(
    idUsuario: json['idUsuario'] as int,
    login: json['login'] as String,
    status: json['status'] as int,
    tipoFormulario: json['tipoFormulario'] as int,
    container: json['container'] == null
        ? null
        : Container.fromJson(json['container'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SincronizarContainerToJson(
        SincronizarContainer instance) =>
    <String, dynamic>{
      'idUsuario': instance.idUsuario,
      'login': instance.login,
      'status': instance.status,
      'tipoFormulario': instance.tipoFormulario,
      'container': instance.container,
    };
