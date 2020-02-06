// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_logs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeLogs _$TimeLogsFromJson(Map<String, dynamic> json) {
  return TimeLogs(
    json['dataInicial'] as String,
    json['dataTermino'] as String,
    json['ocorrencia'] as String,
  );
}

Map<String, dynamic> _$TimeLogsToJson(TimeLogs instance) => <String, dynamic>{
      'dataInicial': instance.dataInicial,
      'dataTermino': instance.dataTermino,
      'ocorrencia': instance.ocorrencia,
    };
