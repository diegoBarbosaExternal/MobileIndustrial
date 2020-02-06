import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/login_bloc.dart';
import 'package:sugar/src/ui/home/home.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
//  TextEditingController _usuario = TextEditingController(text: "ARABELO");
//  TextEditingController _senha = TextEditingController(text: "coper123");

  TextEditingController _usuario = TextEditingController();
  TextEditingController _senha = TextEditingController();
  MyWidget _myWidget = MyWidget();
  FocusNode _focusNodeUsuario = new FocusNode();
  FocusNode _focusNodeSenha = new FocusNode();

  final LoginBloc blocLogin = BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usuario.dispose();
    _senha.dispose();
    _focusNodeUsuario.dispose();
    _focusNodeSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logoAfl = AssetImage('assets/images/logo_afl.png');

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                            child: StreamBuilder<bool>(
                                initialData: false,
                                stream: blocLogin.outAutoValidate,
                                builder: (context, snapshot) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: _myWidget.textFormField(
                                            _usuario,
                                            FlutterI18n.translate(
                                                context, "telaLogin.usuario"),
                                            FlutterI18n.translate(
                                                context, "telaLogin.msgUsuario"),
                                            false,
                                            typeText: TextInputType.emailAddress,
                                            verificarValidate: true,
                                            disableFocusNode: _focusNodeUsuario,
                                            autoValidate: snapshot.data),
                                      ),
                                      Flexible(
                                          child: _myWidget.textFormField(
                                              _senha,
                                              FlutterI18n.translate(
                                                  context, "telaLogin.senha"),
                                              FlutterI18n.translate(
                                                  context, "telaLogin.msgSenha"),
                                              true,
                                              verificarValidate: true,
                                              disableFocusNode: _focusNodeSenha,
                                              autoValidate: snapshot.data))
                                    ],
                                  );
                                }),
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
                      child: StreamBuilder<bool>(
                          initialData: false,
                          stream: blocLogin.outAutoValidate,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              elevation: 10.0,
                              splashColor: Colors.white,
                              onPressed: () async {
                                if (!snapshot.data) {
                                  blocLogin.inAutoValidate.add(true);
                                }
                                if (_formKey.currentState.validate()) {
                                  showDialog<Null>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent,
                                          title: Center(child: Text(
                                            FlutterI18n.translate(
                                                context,
                                                "telaLogin.msgAposLogin"),
                                            style: TextStyle(
                                                color: Colors.white),),),
                                          titlePadding: const EdgeInsets.all(
                                              20.0),
                                          children: <Widget>[
                                            Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Color.fromARGB(
                                                    255, 243, 112, 33),
                                                valueColor: AlwaysStoppedAnimation<
                                                    Color>(Colors.white),

                                              ),
                                            )
                                          ],
                                        );
                                      });
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  bool autenticado = false;
                                  autenticado = await blocLogin.login(
                                      login: _usuario.text.trim(),
                                      senha: _senha.text.trim(),
                                      context: context);

                                  if (autenticado) {
                                    _focusNodeSenha.unfocus();
                                    _focusNodeUsuario.unfocus();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                FlutterI18n.translate(
                                    context, "telaLogin.logar"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                              color: Color.fromARGB(255, 243, 112, 33),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
