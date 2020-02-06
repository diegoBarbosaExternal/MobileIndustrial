import 'package:flutter/material.dart';
import 'package:sugar/src/ui/widgets/drawer.dart';

class Dica extends StatelessWidget {
  static const String route = '/dica';
  BuildDrawer _buildDrawer = BuildDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicas e truques'),
        backgroundColor: Color.fromARGB(255, 080, 079, 081),
      ),
      drawer: _buildDrawer.buildDrawer(context, route),
      body: Container(), // Aqui deve ser chamado as paginas dentro do pacote UI
    );
  }
}
