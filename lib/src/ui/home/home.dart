import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/ui/pages/formularios.dart';

class Home extends StatelessWidget {
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocProvider(
      child: Formularios(),
      tagText: 'tipoFormulario',
      blocs: [Bloc((i) => TipoFormularioBloc())],
    ));
  }
}
