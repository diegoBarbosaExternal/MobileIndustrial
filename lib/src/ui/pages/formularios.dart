import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/ui/widgets/alert_dialog_custom.dart';
import 'package:sugar/src/ui/widgets/drawer.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

/// Diego Gomes Barbosa - diego.barbosa.external@sgs.com - 31/01/2020
/// Continuando projeto WebSugar Mobile.

class Formularios extends StatefulWidget {
  @override
  _FormulariosState createState() => _FormulariosState();
}

class _FormulariosState extends State<Formularios> {
  static const String route = '/home';
  BuildDrawer _buildDrawer = BuildDrawer();
  BreakBulk breakBulk = BreakBulk.padrao();
  ListNaoSincronizados _lns = ListNaoSincronizados();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  final blocTipoFormulario =
  BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();
  List<BreakBulk> listBreakBulk = [];

  @override
  void initState() {
    getFormulario().then((form) {
      blocSugar.sinkLisInicial.add(form);
      blocSugar.sinkFormularioInicial.add(form);
    });

    blocSugar.getSugarDropDown();
    BreakBulkBloc breakBulkBloc = BreakBulkBloc();
    listBreakBulk = breakBulkBloc.listBreakBulks;
    blocTipoFormulario.sinkTipoformulario.add(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          drawer: _buildDrawer.buildDrawer(context, route),
          appBar: AppBar(
            title: Text(
                FlutterI18n.translate(context, "telaFormularios.appBarTitulo")),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 080, 079, 081),
            bottom:
            TabBar(indicatorColor: Color.fromARGB(255, 243, 112, 33), tabs: [
              Tab(text: "Break Bulk"),
              Tab(text: "Container"),
            ]),
          ),

          body: TabBarView(children: [
            StreamBuilder<Formulario>(/// Lista BreakBulk
              stream: blocSugar.outListInicial,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 243, 112, 33),
                            valueColor: AlwaysStoppedAnimation(Colors.white)));
                  case ConnectionState.active:
                    return _lns.listNaoSincrozinados(
                      formulario: snapshot.data,
                      tipoForm: 1,
                      context: context,
                    );
                  default:
                    return Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context,
                            "msgValidacoesTelaFormularios.msgListaBreakBulk")),
                        Text('${snapshot.error}')
                      ],
                    );
                }
              },
            ),
            StreamBuilder<Formulario>(/// Lista Container
              stream: blocSugar.outListInicial,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 243, 112, 33),
                            valueColor: AlwaysStoppedAnimation(Colors.white)));
                  case ConnectionState.active:
                    return _lns.listNaoSincrozinados(
                      formulario: snapshot.data,
                      tipoForm: 2,
                      context: context,
                    );
                  default:
                    return Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context,
                            "msgValidacoesTelaFormularios.msgListaContainer")),
                        Text('${snapshot.error}')
                      ],
                    );
                }
              },
            )
          ]),
          backgroundColor: Colors.white,
          // Aqui deve ser chamado as paginas dentro do pacote UI
          floatingActionButton: FloatingActionButton(
            heroTag: 'btnFormulario',
            backgroundColor: Color.fromARGB(255, 243, 112, 33),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogCustom();
                  });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Future<Formulario> getFormulario() async {
    Formulario form = await blocSugar.getFormularioSugar();
    return form;
  }
}
