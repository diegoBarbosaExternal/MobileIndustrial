import 'package:flutter/material.dart';
import 'package:sugar/src/ui/widgets/drawer.dart';

class Ajuda extends StatelessWidget {
  static const String route = '/ajuda';
  BuildDrawer _buildDrawer = BuildDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda'),
        backgroundColor: Color.fromARGB(255, 080, 079, 081),
      ),
      drawer: _buildDrawer.buildDrawer(context, route),
      body: Container(), // Aqui deve ser chamado as paginas dentro do pacote UI
    );
  }
}
