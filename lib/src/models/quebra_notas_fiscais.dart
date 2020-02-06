import 'package:sugar/src/models/quebra_nota.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quebra_notas_fiscais.g.dart';

@JsonSerializable()
class QuebraNotasFiscais {
  String container;
  List<QuebraNota> quebraNotas;

  QuebraNotasFiscais.padrao();

  QuebraNotasFiscais(
      this.container,
      this.quebraNotas);

  factory QuebraNotasFiscais.fromJson(Map<String, dynamic> json) =>
      _$QuebraNotasFiscaisFromJson(json);

  Map<String, dynamic> toJson() => _$QuebraNotasFiscaisToJson(this);
}
