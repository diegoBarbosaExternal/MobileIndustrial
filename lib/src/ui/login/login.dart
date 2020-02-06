import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sugar/src/ui/home/formularios.dart';

import 'package:sugar/src/ui/widgets/form_text_field.dart';

import 'alterar_senha.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usuario = TextEditingController();
  TextEditingController _senha = TextEditingController();
  bool _autoValidate = false;
  MyWidget _myWidget = MyWidget();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const logoAfl = AssetImage('assets/images/logo_afl.png');

    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 080, 079, 081),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15),
                  child: Center(
                      child: Image(
                    image: logoAfl,
                    width: 150.0,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.37),
                  child: Card(
                      margin: EdgeInsets.all(20.0),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.27,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 15.0, left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: _myWidget.textFormField(_usuario,
                                    'Email', 'Email é obrigatorio.', false,
                                    typeText: TextInputType.emailAddress,
                                    autoValidate: _autoValidate),
                              ),
                              Flexible(
                                  child: _myWidget.textFormField(_senha,
                                      'Senha', 'Senha é obrigatorio.', true,
                                      autoValidate: _autoValidate))
                            ],
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.75,
                      left: MediaQuery.of(context).size.width * 0.10),
                  child: Container(
                    height: 45.0,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: RaisedButton(
                      elevation: 10.0,
                      splashColor: Colors.white,
                      onPressed: () {
                        if (_autoValidate == false) {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                        if (_formKey.currentState.validate()) {
                          //Colocar ação para gravar
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Formularios()));
                        }
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                      color: Color.fromARGB(255, 243, 112, 33),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Esqueci ',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 080, 079, 081)),
                  ),
                  GestureDetector(
                    child: Text(
                      'minha senha!',
                      style:
                          TextStyle(color: Color.fromARGB(255, 243, 112, 33)),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlterarSenha()),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
