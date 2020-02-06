import 'package:sugar/src/models/breakbulk.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:sugar/src/models/container.dart';

part 'sincronizar_container.g.dart';

@JsonSerializable()
class SincronizarContainer {
  int idUsuario;
  String login;
  int status;
  int tipoFormulario;
  Container container;

  SincronizarContainer.padrao();

  SincronizarContainer(
      {this.idUsuario,
      this.login,
      this.status,
      this.tipoFormulario,
      this.container});

  factory SincronizarContainer.fromJson(Map<String, dynamic> json) =>
      _$SincronizarContainerFromJson(json);

  Map<String, dynamic> toJson() => _$SincronizarContainerToJson(this);
}
