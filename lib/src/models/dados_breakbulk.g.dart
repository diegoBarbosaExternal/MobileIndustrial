// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dados_breakbulk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DadosBreakBulk _$DadosBreakBulkFromJson(Map<String, dynamic> json) {
  return DadosBreakBulk(
    json['ordemDeServico'] as String,
    json['clientePrincipal'] as String,
    json['localTerminal'] as String,
    json['produto'] == null
        ? null
        : Produto.fromJson(json['produto'] as Map<String, dynamic>),
    json['navio'] as String,
    json['origem'] as String,
    (json['caminhoesVagoesRegistrados'] as List)
        ?.map((e) => e == null
            ? null
            : CaminhoesVagoes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['resumo'] as String,
    (json['timeLogs'] as List)
        ?.map((e) =>
            e == null ? null : TimeLogs.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['embarquesRegistrados'] as List)
        ?.map((e) =>
            e == null ? null : Embarque.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['recebimentosRegistrados'] as List)
        ?.map((e) =>
            e == null ? null : Recebimento.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['inspetorSgs'] as String,
    json['terminal'] as String,
  )..dataReferencia = json['dataReferencia'] as String;
}

Map<String, dynamic> _$DadosBreakBulkToJson(DadosBreakBulk instance) =>
    <String, dynamic>{
      'dataReferencia': instance.dataReferencia,
      'ordemDeServico': instance.ordemDeServico,
      'clientePrincipal': instance.clientePrincipal,
      'localTerminal': instance.localTerminal,
      'produto': instance.produto,
      'navio': instance.navio,
      'origem': instance.origem,
      'caminhoesVagoesRegistrados': instance.caminhoesVagoesRegistrados,
      'resumo': instance.resumo,
      'timeLogs': instance.timeLogs,
      'embarquesRegistrados': instance.embarquesRegistrados,
      'recebimentosRegistrados': instance.recebimentosRegistrados,
      'inspetorSgs': instance.inspetorSgs,
      'terminal': instance.terminal,
    };
