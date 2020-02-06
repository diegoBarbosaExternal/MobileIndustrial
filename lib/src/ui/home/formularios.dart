import 'package:flutter/material.dart';
import 'package:sugar/src/ui/widgets/alert_dialog_custom.dart';
import 'package:sugar/src/ui/widgets/drawer.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class Formularios extends StatelessWidget {
  static const String route = '/formulario';
  BuildDrawer _buildDrawer = BuildDrawer();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Formulários'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.sync), onPressed: () {})
          ],
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 080, 079, 081),
          bottom:
              TabBar(indicatorColor: Color.fromARGB(255, 243, 112, 33), tabs: [
            Tab(text: "Break Bulk"),
            Tab(text: "Container"),
          ]),
        ),
        drawer: _buildDrawer.buildDrawer(context, route),
        body: TabBarView(children: [
          ListNaoSincronizados(10, "SA11901035"),
          ListNaoSincronizados(10, "SA11901035"),
        ]),
        backgroundColor: Colors.white,
        // Aqui deve ser chamado as paginas dentro do pacote UI
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () {
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
    );
  }
}
