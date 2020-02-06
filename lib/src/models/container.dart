import 'package:sugar/src/models/dados_container.dart';

import 'package:json_annotation/json_annotation.dart';

part 'container.g.dart';

@JsonSerializable()
class Container {
  String uuid;
  String status;
  String nomeFormulario;
  DadosContainer dadoscontainer;

  Container(this.uuid, this.status, this.dadoscontainer, this.nomeFormulario);

  Container.padrao();

  factory Container.fromJson(Map<String, dynamic> json) =>
      _$ContainerFromJson(json);

  Map<String, dynamic> toJson() => _$ContainerToJson(this);


}
