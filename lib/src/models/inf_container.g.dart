// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inf_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InformacaoContainer _$InformacaoContainerFromJson(Map<String, dynamic> json) {
  return InformacaoContainer(
    json['inspecao'] as bool,
    json['estufagem'] as bool,
    json['desova'] as bool,
    json['dataHoraInicioInspecao'] as String,
    json['dataHoraFimInspecao'] as String,
    json['dataHoraInicioEstuDeso'] as String,
    json['dataHoraFimEstuDeso'] as String,
    json['numeroContainer'] as String,
    (json['tara'] as num)?.toDouble(),
    json['capacidade'] as int,
    json['dataFabricacao'] as String,
    json['condicao'] as bool,
    json['razaoRejeicao'] as String,
    json['temperatura'] as String,
    json['lacreSgs7Metros'] as int,
    json['lacreDefinitivo'] as int,
    json['lacreAgencia'] as String,
    json['lacreOutros'] as int,
    json['lote'] as String,
    json['data'] as String,
    (json['controleDeQuantidade'] as List)?.map((e) => e as int)?.toList(),
    json['total'] as int,
  )..produto = json['produto'] as String;
}

Map<String, dynamic> _$InformacaoContainerToJson(
        InformacaoContainer instance) =>
    <String, dynamic>{
      'inspecao': instance.inspecao,
      'estufagem': instance.estufagem,
      'desova': instance.desova,
      'dataHoraInicioInspecao': instance.dataHoraInicioInspecao,
      'dataHoraFimInspecao': instance.dataHoraFimInspecao,
      'dataHoraInicioEstuDeso': instance.dataHoraInicioEstuDeso,
      'dataHoraFimEstuDeso': instance.dataHoraFimEstuDeso,
      'numeroContainer': instance.numeroContainer,
      'tara': instance.tara,
      'capacidade': instance.capacidade,
      'produto': instance.produto,
      'dataFabricacao': instance.dataFabricacao,
      'condicao': instance.condicao,
      'razaoRejeicao': instance.razaoRejeicao,
      'temperatura': instance.temperatura,
      'lacreSgs7Metros': instance.lacreSgs7Metros,
      'lacreDefinitivo': instance.lacreDefinitivo,
      'lacreAgencia': instance.lacreAgencia,
      'lacreOutros': instance.lacreOutros,
      'lote': instance.lote,
      'data': instance.data,
      'controleDeQuantidade': instance.controleDeQuantidade,
      'total': instance.total,
    };
