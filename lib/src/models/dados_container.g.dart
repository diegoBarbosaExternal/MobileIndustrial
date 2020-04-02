// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dados_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DadosContainer _$DadosContainerFromJson(Map<String, dynamic> json) {
  return DadosContainer(
    json['inspecao'] as bool,
    json['estufagem'] as bool,
    json['desova'] as bool,
    json['matricula'] as String,
    json['ordemServico'] as String,
    json['clientePrincipal'] as String,
    json['localTerminal'] as String,
    json['produto'] == null
        ? null
        : Produto.fromJson(json['produto'] as Map<String, dynamic>),
    json['booking'] as String,
    json['navio'] as String,
    json['identificacaoEquipamento'] as String,
    json['numeroCertificado'] as String,
    json['dataVerificacao'] as String,
    json['descricaoEmbalagem'] as String,
    json['planoAmostragem'] as String,
    json['identificacaoDosVolumes'] as String,
    json['doubleCheck'] as bool,
    json['empresa'] as String,
    json['lacreDasAmostras'] as int,
    json['resumo'] as String,
    (json['containersRegistrados'] as List)
        ?.map((e) => e == null
            ? null
            : InformacaoContainer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['timeLogs'] as List)
        ?.map((e) =>
            e == null ? null : TimeLogs.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['usinaSP'] == null
        ? null
        : Usina.fromJson(json['usinaSP'] as Map<String, dynamic>),
    json['marcaDaBalanca'] as String,
    json['numeroDeSerie'] as String,
    json['ultimaCalibracao'] as String,
    json['numeroDoLacre'] as String,
    (json['pesoSacas'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    (json['totalKg'] as num)?.toDouble(),
    json['unidadesPesadas'] as int,
    (json['media'] as num)?.toDouble(),
    (json['taraDaUnidade'] as num)?.toDouble(),
    (json['mediaDoPesoLiquido'] as num)?.toDouble(),
    json['companhia'] as String,
    json['front'] as String,
    json['back'] as String,
    json['inkjet'] as String,
    (json['quebraNotasFiscais'] as List)
        ?.map((e) => e == null
            ? null
            : QuebraNotasFiscais.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['inspetorSgs'] as String,
    json['terminal'] as String,
  );
}

Map<String, dynamic> _$DadosContainerToJson(DadosContainer instance) =>
    <String, dynamic>{
      'inspecao': instance.inspecao,
      'estufagem': instance.estufagem,
      'desova': instance.desova,
      'matricula': instance.matricula,
      'ordemServico': instance.ordemServico,
      'clientePrincipal': instance.clientePrincipal,
      'localTerminal': instance.localTerminal,
      'produto': instance.produto,
      'booking': instance.booking,
      'navio': instance.navio,
      'identificacaoEquipamento': instance.identificacaoEquipamento,
      'numeroCertificado': instance.numeroCertificado,
      'dataVerificacao': instance.dataVerificacao,
      'descricaoEmbalagem': instance.descricaoEmbalagem,
      'planoAmostragem': instance.planoAmostragem,
      'identificacaoDosVolumes': instance.identificacaoDosVolumes,
      'doubleCheck': instance.doubleCheck,
      'empresa': instance.empresa,
      'lacreDasAmostras': instance.lacreDasAmostras,
      'resumo': instance.resumo,
      'containersRegistrados': instance.containersRegistrados,
      'timeLogs': instance.timeLogs,
      'usinaSP': instance.usinaSP,
      'marcaDaBalanca': instance.marcaDaBalanca,
      'numeroDeSerie': instance.numeroDeSerie,
      'ultimaCalibracao': instance.ultimaCalibracao,
      'numeroDoLacre': instance.numeroDoLacre,
      'pesoSacas': instance.pesoSacas,
      'totalKg': instance.totalKg,
      'unidadesPesadas': instance.unidadesPesadas,
      'media': instance.media,
      'taraDaUnidade': instance.taraDaUnidade,
      'mediaDoPesoLiquido': instance.mediaDoPesoLiquido,
      'companhia': instance.companhia,
      'front': instance.front,
      'back': instance.back,
      'inkjet': instance.inkjet,
      'quebraNotasFiscais': instance.quebraNotasFiscais,
      'inspetorSgs': instance.inspetorSgs,
      'terminal': instance.terminal,
    };
