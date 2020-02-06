import 'dart:ui';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:signature/signature.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/ui/pages/insp_estuf_desova.dart';
import 'package:sugar/src/ui/pages/supervisao_de_peso.dart';
import 'package:sugar/src/ui/widgets/awasome_dialog.dart';
import 'package:sugar/src/utils/cores.dart' as Cores;

class AssinaturaDigitalPage extends StatefulWidget {
  @override
  _AssinaturaDigitalPageState createState() => _AssinaturaDigitalPageState();
}

class _AssinaturaDigitalPageState extends State<AssinaturaDigitalPage>
    with AutomaticKeepAliveClientMixin {
  final blocTP =
      BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();
  var blocAssinatura;

  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  String nomeForm = "";

  @override
  void initState() {
    blocTP.getTipo() == 1
        ? blocAssinatura =
            BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>()
        : blocAssinatura =
            BlocProvider.tag('container').getBloc<ContainerBloc>();
    super.initState();
  }

  @override
  void dispose() {
    blocSugar.getFormulario();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        FlutterI18n.translate(
                            context, "assinaturaDigital.assinaturaInspetorSGS"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0)),
                    CardAssinatura(
                      tipoAssinatura: 1,
                      blocAssinatura: blocAssinatura,
                    ),
                    StreamBuilder<bool>(
                        stream: blocAssinatura.outValidaAssinaturaInspetorBloc,
                        builder: (context, snapshot) {
                          if (snapshot.data == false) {
                            return SizedBox();
                          } else {
                            return Text(
                              FlutterI18n.translate(context,
                                  "assinaturaDigital.msgAssinaturaInspetorObrigatorio"),
                              style: TextStyle(color: Colors.red),
                            );
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        FlutterI18n.translate(
                            context, "assinaturaDigital.assinaturaTerminal"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0)),
                    CardAssinatura(
                      tipoAssinatura: 2,
                      blocAssinatura: blocAssinatura,
                    ),
                    StreamBuilder<bool>(
                      stream: blocAssinatura.outValidaAssinaturaTerminalBloc,
                      builder: (context, snapshot) {
                        if (snapshot.data == false) {
                          return SizedBox();
                        } else {
                          return Text(
                            FlutterI18n.translate(context,
                                "assinaturaDigital.msgAssinaturaTerminalObrigatorio"),
                            style: TextStyle(color: Colors.red),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 20, right: 20, left: 20),
                      child: StreamBuilder<bool>(
                        stream: blocAssinatura.outIsSave,
                        initialData: false,
                        builder: (context, snapshot) {
                          return RaisedButton(
                            elevation: 10.0,
                            splashColor: Colors.white,
                            onPressed: snapshot.data
                                ? null
                                : () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                                    bool insp = blocAssinatura
                                        .validarAssinaturaInspetor();
                                    bool term = blocAssinatura
                                        .validarAssinaturaTerminal();

                                    if (insp && term) {
                                      if (blocTP.getTipo() == 1) {
                                        if (await validateSuperEmbReceb() &&
                                            validateCaminhoesVagoes() &&
                                            validateTimeLogs()) {
                                          if (blocTP.getTipoOperacao == 1) {
                                            if (validateRecebimento()) {
                                              finalizarFormulario();
                                            }
                                          } else {
                                            if (validateEmbarque()) {
                                              finalizarFormulario();
                                            }
                                          }
                                        }
                                      } else {
                                        if (validateInspEstuDeso() &&
                                            validateTimeLogs() &&
                                            await validateSupervisaoPeso() &&
                                            validateQuebraNota()) {
                                          finalizarFormulario();
                                        }
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                          FlutterI18n.translate(context,
                                              "msgValidacoesTelaAssinaturaDigital.msgCamposObrigatorios"),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  },
                            child: Text(
                              FlutterI18n.translate(context,
                                  "assinaturaDigital.btnFinalizarSincronizar"),
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            color: Color.fromARGB(255, 243, 112, 33),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder<bool>(
                stream: blocAssinatura.outIsSave,
                initialData: false,
                builder: (context, snapshot) {
                  return IgnorePointer(
                    ignoring: !snapshot.data,
                    child: Container(
                      color: snapshot.data
                          ? Colors.black.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  finalizarFormulario() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

      showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Center(
                child: Text(
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaAssinaturaDigital.msgSincronizandoDados"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              titlePadding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 243, 112, 33),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              ],
            );
          });

      bool salvo;
      salvo = await blocAssinatura
          .salvarAssinaturaDigital(blocSugar.valueUUIDFormAtual);

      if (salvo) {
        bool sincronizado;
        blocTP.getTipo() == 1
            ? sincronizado = await blocAssinatura
                .sincronizarBreakBulk(blocSugar.valueUUIDFormAtual)
            : sincronizado = await blocAssinatura
                .sincronizarContainer(blocSugar.valueUUIDFormAtual);

        Scaffold.of(context).removeCurrentSnackBar();

        if (sincronizado) {
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              FlutterI18n.translate(context,
                  "msgValidacoesTelaAssinaturaDigital.msgDadosSincronizadosComSucesso"),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.green,
          ));
          Future.delayed(Duration(seconds: 4)).then((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              FlutterI18n.translate(context,
                  "msgValidacoesTelaAssinaturaDigital.msgErroAoSincronizar"),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            FlutterI18n.translate(context,
                "msgValidacoesTelaAssinaturaDigital.msgErroAoSalvarAD"),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      AwasomeDialog awasome = AwasomeDialog();
      awasome.awasomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.SCALE,
          title: 'Erro ao sincronizar',
          text: Column(
            children: <Widget>[
              Center(
                child: Text("Ops...",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaAssinaturaDigital.msgErroSemConexaoInternet"),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          btnOkColor: Color.fromARGB(255, 243, 112, 33));
    }
  }

  Future<bool> validateSuperEmbReceb() async {
    blocAssinatura.inAutoValidateSuperEmbReceb.add(true);
    if (blocAssinatura.keyFormSuperEmbRece.currentState.validate() &&
        blocAssinatura.keyComboProdutoSuperEmbRec.currentState.validate()) {
      await blocAssinatura.salvarSuperEmbReceb(blocSugar.valueUUIDFormAtual);
      return true;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgCamposObrigatoriosSuperEmbReceb"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  bool validateCaminhoesVagoes() {
    if (blocAssinatura.getListCaminhoesVagoes != null &&
        blocAssinatura.getListCaminhoesVagoes.isNotEmpty &&
        blocAssinatura.getListCaminhoesVagoes.length > 0) {
      return true;
    } else {
      blocAssinatura.inAutoValidateCaminhoesVagoes.add(true);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoCaminhaoVagao"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  bool validateTimeLogs() {
    if (blocAssinatura.getListTimeLogs != null &&
        blocAssinatura.getListTimeLogs.isNotEmpty &&
        blocAssinatura.getListTimeLogs.length > 0) {
      return true;
    } else {
      blocAssinatura.inAutoValidateTimeLogs.add(true);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoTimeLogs"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  bool validateEmbarque() {
    if (blocAssinatura.getListEmbarque != null &&
        blocAssinatura.getListEmbarque.isNotEmpty &&
        blocAssinatura.getListEmbarque.length > 0) {
      return true;
    } else {
      blocAssinatura.inAutoValidateEmbarque.add(true);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoEmbarque"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  bool validateRecebimento() {
    if (blocAssinatura.getListRecebimento != null &&
        blocAssinatura.getListRecebimento.isNotEmpty &&
        blocAssinatura.getListRecebimento.length > 0) {
      return true;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoRecebimento"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      blocAssinatura.inAutoValidateRecebimento.add(true);
      blocAssinatura.keyFormRecebimento.currentState.validate();
      blocAssinatura.keyComboTipoUsina.currentState.validate();
      blocAssinatura.keyComboTurno.currentState.validate();
      blocAssinatura.keyComboUsinaRecebimento.currentState.validate();
      return false;
    }
  }

  bool validateInspEstuDeso() {
    InspecaoEstufagemDesovaState inspEstuDes = InspecaoEstufagemDesovaState();
    if (inspEstuDes.validateInspEstuDesoResumido()) {
      return true;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoInspEstufDeso"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future<bool> validateSupervisaoPeso() async {
    SupervisaoDePesoState supervisaoDePeso = SupervisaoDePesoState();
    try {
      if (supervisaoDePeso.validateSupervisaoPeso() &&
          await blocAssinatura
              .validateSupervisaoPeso(blocSugar.valueUUIDFormAtual)) {
        return true;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            FlutterI18n.translate(context,
                "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoSuperDePeso"),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgCriarTelaSupervisaoDePeso"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  validateQuebraNota() {
    if (blocAssinatura.listInicialQuebraDeNota != null &&
        blocAssinatura.listInicialQuebraDeNota.isNotEmpty &&
        blocAssinatura.listInicialQuebraDeNota.length > 0) {
      return true;
    } else {
      blocAssinatura.inAutoValidateQuebraNota.add(true);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          FlutterI18n.translate(context,
              "msgValidacoesTelaAssinaturaDigital.msgSalvarAoMenosUmaInformacaoQuebraDeNota"),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CardAssinatura extends StatelessWidget {
  int tipoAssinatura;
  var blocAssinatura;

  CardAssinatura({this.blocAssinatura, this.tipoAssinatura});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: tipoAssinatura == 1
            ? blocAssinatura.outAssinaturaInspetorBloc
            : blocAssinatura.outAssinaturaTerminalBloc,
        builder: (context, snapshot) {
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.90,
              height: 100.0,
              child: Card(
                elevation: 8.0,
                child: Center(
                    child: StreamBuilder<dynamic>(
                        stream: tipoAssinatura == 1
                            ? blocAssinatura.outAssinaturaInspetorBloc
                            : blocAssinatura.outAssinaturaTerminalBloc,
                        builder: (context, snapshot) {
                          return snapshot.data == null
                              ? Text(
                                  FlutterI18n.translate(context,
                                      "assinaturaDigital.toqueAquiParaAssinar"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )
                              : Image.memory(base64.decode(snapshot.data));
                        })),
              ),
            ),
            onTap: () {
              showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Assinatura(
                      tipoAssinatura: tipoAssinatura,
                      blocAssinatura: blocAssinatura,
                    );
                  });
            },
          );
        });
  }
}

class Assinatura extends StatelessWidget {
  int tipoAssinatura;
  var _signatureCanvas;
  var blocAssinatura;

  Assinatura({this.blocAssinatura, this.tipoAssinatura});

  @override
  Widget build(BuildContext context) {
    _signatureCanvas = Signature(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.50,
      backgroundColor: Colors.white,
    );

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
      child: Column(
        children: <Widget>[
          _signatureCanvas,
          Material(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 50,
                decoration: const BoxDecoration(
                  color: Cores.CINZA_ESCURO,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Cores.LARANJA,
                      onPressed: () async {
                        if (_signatureCanvas.isNotEmpty) {
                          var data = await _signatureCanvas.exportBytes();
                          if (tipoAssinatura == 1) {
                            blocAssinatura.inAssinaturaInspetorBloc
                                .add(base64.encode(data));
                            Navigator.pop(
                              context,
                            );
                            blocAssinatura.validarAssinaturaInspetor();
                          } else if (tipoAssinatura == 2) {
                            blocAssinatura.inAssinaturaTerminalBloc
                                .add(base64.encode(data));
                            Navigator.pop(context);
                            blocAssinatura.validarAssinaturaTerminal();
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Cores.LARANJA,
                      onPressed: () {
                        return _signatureCanvas.clear();
                      },
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
