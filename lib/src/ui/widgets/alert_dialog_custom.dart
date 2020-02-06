import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/numero_container_bloc.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/ui/pages/home_break_bulk.dart';
import 'package:sugar/src/ui/pages/home_container.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';

class AlertDialogCustom extends StatefulWidget {
  @override
  _AlertDialogCustomState createState() => _AlertDialogCustomState();
}

class _AlertDialogCustomState extends State<AlertDialogCustom> {
  int _valor = 0;
  int _operacao;
  MyWidget _tff = MyWidget();
  final _nomeBookingController = TextEditingController();
  final bloc = BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();
  final blocAlertDialog = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var keyformTipoForm = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    bloc.sinkTipoformulario.add(null);
    super.initState();
  }

  double maxValue(double value, double max) {
    if (value < max) {
      return value;
    } else {
      return max;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Dialog(
        backgroundColor: Colors.transparent,
        child: StreamBuilder<int>(
          initialData: 0,
          stream: bloc.outTipoFomulario,
          builder: (context, snapshot) {
            return Card(
              child: Form(
                key: keyformTipoForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(
                              context, "tipoDeFormulario.tipoFormulario"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                  activeColor:
                                      Color.fromARGB(255, 243, 112, 33),
                                  value: 1,
                                  groupValue: _valor,
                                  onChanged: (selc) {
                                    _valor = selc;
                                    bloc.sinkTipoformulario.add(_valor);
                                  }),
                              Text("Break Bulk",
                                  style: TextStyle(
                                      fontSize:
                                          maxValue(size.width * 0.03, 16)))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                  activeColor:
                                      Color.fromARGB(255, 243, 112, 33),
                                  value: 2,
                                  groupValue: _valor,
                                  onChanged: (selc) {
                                    _valor = selc;
                                    bloc.sinkTipoformulario.add(_valor);
                                  }),
                              Text("Container",
                                  style: TextStyle(
                                      fontSize:
                                          maxValue(size.width * 0.03, 16))),
                            ],
                          )
                        ],
                      ),
                    ),
                    _valor != 0
                        ? StreamBuilder<int>(
                            initialData: 0,
                            stream: bloc.outTipoOperacaoBreakBulk,
                            builder: (context, snapshot) {
                              return _valor == 1
                                  ? Container(
                                      padding: const EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(
                                    left: maxValue(size.width * 0.05, 20),
                                    right:
                                    maxValue(size.width * 0.05, 20)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                5.0) //         <--- border radius here
                                            ),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 243, 112, 33)),
                                      ), //       <--- BoxDecoration here
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              FlutterI18n.translate(context,
                                                  "tipoDeFormulario.msgEscolherOperacao"),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Radio(
                                                      activeColor:
                                                          Color.fromARGB(255,
                                                              243, 112, 33),
                                                      value: 1,
                                                      groupValue: _operacao,
                                                      onChanged: (selecionado) {
                                                        _operacao = selecionado;
                                                        bloc.sinkTipoOperacaoBreakBulk
                                                            .add(_operacao);
                                                      }),
                                                  Text(
                                                      FlutterI18n.translate(
                                                          context,
                                                          "breakbulkRecebimento.tituloTabBar"),
                                                      style: TextStyle(
                                                          fontSize: maxValue(
                                                              size.width * 0.03,
                                                              16))),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Radio(
                                                      activeColor:
                                                          Color.fromARGB(255,
                                                              243, 112, 33),
                                                      value: 2,
                                                      groupValue: _operacao,
                                                      onChanged: (selecionado) {
                                                        _operacao = selecionado;
                                                        bloc.sinkTipoOperacaoBreakBulk
                                                            .add(_operacao);
                                                      }),
                                                  Text(
                                                      FlutterI18n.translate(
                                                          context,
                                                          "breakbulkEmbarque.tituloTabBar"),
                                                      style: TextStyle(
                                                          fontSize: maxValue(
                                                              size.width * 0.03,
                                                              16))),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : _tff.textFormField(
                                      _nomeBookingController,
                                      "Booking",
                                      FlutterI18n.translate(context,
                                          "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                      false,
                                      autoValidate: true,
                                      verificarValidate: true,
                                      campoObrigatorio: true,
                                      maxLength: 20,
                                      typeText: TextInputType.text,
                                    );
                            })
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Color.fromARGB(255, 243, 112, 33),
                      onPressed: () async {
                        if (snapshot.data != null) {
                          if (snapshot.data == 1) {
                            if (_operacao == null) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  FlutterI18n.translate(context,
                                      "tipoDeFormulario.escolherOperacao"),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                backgroundColor:
                                Color.fromARGB(255, 243, 112, 33),
                              ));
                            } else {
                              await blocAlertDialog.criarFormBreakBulk();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider(
                                            tagText: "breakbulk",
                                            blocs: [
                                              Bloc((i) => BreakBulkBloc()),
                                            ],
                                            child: HomeBreakBulk(),
                                          )));
                            }
                          } else if (snapshot.data == 2) {
                            if (keyformTipoForm.currentState.validate()) {
                              await blocAlertDialog.criarFormContainer(
                                  nomeFormContainer:
                                      _nomeBookingController.text);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            tagText: "container",
                                            blocs: [
                                              Bloc((i) => ContainerBloc()),
                                              Bloc((i) =>
                                                  DropDowBlocNumeroDoContainer()),
                                            ],
                                            child: HomeContainer(),
                                          )));
                            }
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              FlutterI18n.translate(context,
                                  "tipoDeFormulario.msgEscolherFormulario"),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            backgroundColor: Color.fromARGB(255, 243, 112, 33),
                          ));
                        }
                      },
                      child: Text(
                        FlutterI18n.translate(
                            context, "tipoDeFormulario.btnConfirmar"),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
