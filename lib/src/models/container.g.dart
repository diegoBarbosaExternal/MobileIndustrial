// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Container _$ContainerFromJson(Map<String, dynamic> json) {
  return Container(
    json['uuid'] as String,
    json['status'] as String,
    json['dadoscontainer'] == null
        ? null
        : DadosContainer.fromJson(
            json['dadoscontainer'] as Map<String, dynamic>),
    json['nomeFormulario'] as String,
  );
}

Map<String, dynamic> _$ContainerToJson(Container instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'status': instance.status,
      'nomeFormulario': instance.nomeFormulario,
      'dadoscontainer': instance.dadoscontainer,
    };
