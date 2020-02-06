import 'package:flutter/material.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';

class AlterarSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar senha"),
        backgroundColor: Color.fromARGB(255, 080, 079, 081),
      ),
      body: Center(
        child: Card(
            margin: EdgeInsets.all(20.0),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text('Criar formulario de recuperação  de senha!'),
              ),
            )),
      ),
    );
  }
}
