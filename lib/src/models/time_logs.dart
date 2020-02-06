import 'package:json_annotation/json_annotation.dart';

part 'time_logs.g.dart';

@JsonSerializable()
class TimeLogs {
  String dataInicial;
  String dataTermino;

  String ocorrencia;

  TimeLogs(this.dataInicial, this.dataTermino,
      this.ocorrencia);

  TimeLogs.padrao();

  factory TimeLogs.fromJson(Map<String, dynamic> json) =>
      _$TimeLogsFromJson(json);

  Map<String, dynamic> toJson() => _$TimeLogsToJson(this);
}
