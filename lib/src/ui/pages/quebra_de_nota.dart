import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/numero_container_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/quebra_notas_fiscais.dart';
import 'package:sugar/src/models/tipo_acucar.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/drop_down_validation.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class QuebraDeNota extends StatefulWidget {
  @override
  _QuebraDeNotaState createState() => _QuebraDeNotaState();
}

class _QuebraDeNotaState extends State<QuebraDeNota>
    with AutomaticKeepAliveClientMixin {
  MyWidget _tff = MyWidget();
  ContainerListView clv = ContainerListView();
  LisContainerQuebraDeNota lcqn = LisContainerQuebraDeNota();

  final blocNumeroDoContainer =
      BlocProvider.tag('container').getBloc<DropDowBlocNumeroDoContainer>();
  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  final blocTipoAcucar =
  BlocProvider.tag('sugarGlobal').getBloc<TipoAcucarBloc>();

  final _notaFiscalController = TextEditingController();
  final _placaController = TextEditingController();
  final _totalDeSacasController = MoneyMaskedTextController(      decimalSeparator: '', thousandSeparator: '', precision: 0);
  final _totalPorContainerController = MoneyMaskedTextController(      decimalSeparator: '', thousandSeparator: '', precision: 0);
  final _sobraController = TextEditingController();
  final _avariaController = TextEditingController();
  final _faltaCargaController = TextEditingController();
  final _observacaoController = TextEditingController();


  @override
  void initState() {
    blocSugar.getQuebraNota();
    blocContainer.carregarNumeroContainer(uuid: blocSugar.valueUUIDFormAtual);
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: blocContainer.keyFormQuebraNota,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: blocContainer.outAutoValidateQuebraNota,
                builder: (context, snapshotForm) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[

                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocContainer.keyComboNumeroContainer,
                              child: StreamBuilder<List<String>>(
                                  initialData: [],
                                  stream:
                                  blocNumeroDoContainer
                                      .outListNumeroDosContainers,
                                  builder: (context, snapshot) {
                                    return DropDownFormField.dropDownSugar(
                                      hint: FlutterI18n.translate(context,
                                          "containerQuebraNota.comboNumeroContainer"),
                                      dropDown: DropdownButtonFormField<String>(
                                        decoration:
                                            DropDownFormField.decoratorDropDown(),
                                        validator: (String value) {
                                          if (value == null ||
                                              blocNumeroDoContainer
                                                      .valueNumeroContainer ==
                                                  null) {
                                            return FlutterI18n.translate(context,
                                                "containerQuebraNota.msgNumeroContainerObrigatorio");
                                          } else {
                                            return null;
                                          }
                                        },
                                        hint: Text(
                                          FlutterI18n.translate(context,
                                              "containerQuebraNota.comboNumeroContainer"),
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        value: blocNumeroDoContainer
                                            .valueNumeroContainer,
                                        onChanged: (String value) {
                                          blocNumeroDoContainer
                                              .valueNumeroContainer = value;

                                          blocNumeroDoContainer
                                              .sinkListNumeroDosContainers
                                              .add(blocNumeroDoContainer
                                                  .listValueContainer);
                                          if (snapshotForm.data) {
                                            blocContainer
                                                .keyFormQuebraNota.currentState
                                                .validate();
                                          }
                                        },
                                        items: snapshot.data.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }),
                            ),

                            _tff.textFormField(
                              _notaFiscalController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.notaFiscal"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 10,
                              maxLines: null,
                              typeText: TextInputType.text,
                              stream: blocContainer.outNotaFiscal,
                              onChanged: blocContainer.changeNotaFiscal,
                            ),
                            _tff.textFormField(
                              _placaController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.placa"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 10,
                              maxLines: null,
                              typeText: TextInputType.text,
                              stream: blocContainer.outPlaca,
                              onChanged: blocContainer.changePlaca,
                            ),
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocContainer.keyComboUsinaQuebraNota,
                              child: StreamBuilder<List<Usina>>(
                                  stream: blocUsina.outGenericBloc,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return SizedBox();
                                      case ConnectionState.active:
                                        return DropDownFormField.dropDownSugar(
                                          hint: FlutterI18n.translate(context,
                                              "containerQuebraNota.comboUsinas"),
                                          dropDown:
                                              DropdownButtonFormField<Usina>(
                                            decoration: DropDownFormField
                                                .decoratorDropDown(),
                                            validator: (Usina value) {
                                              if (value == null ||
                                                  blocUsina.valueQuebraNota ==
                                                      null) {
                                                return FlutterI18n.translate(
                                                    context,
                                                    "containerQuebraNota.msgUsinaObrigatorio");
                                              } else {
                                                return null;
                                              }
                                            },
                                                hint: Text(
                                                    FlutterI18n.translate(context,
                                                        "containerQuebraNota.comboUsinas"),
                                                style: TextStyle(fontSize: 15)),
                                            value: blocUsina.valueQuebraNota,
                                            onChanged: (Usina produto) {
                                              blocUsina.valueQuebraNota = produto;
                                              blocUsina.sinkGenericBloc
                                                  .add(blocUsina.usinas);
                                              if (snapshotForm.data) {
                                                blocContainer.keyFormQuebraNota
                                                    .currentState
                                                    .validate();
                                              }
                                            },
                                            items: blocUsina.usinas
                                                .map((Usina usina) {
                                              return DropdownMenuItem<Usina>(
                                                value: usina,
                                                child: Text("${usina.usina}",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      default:
                                        return Row(
                                          children: <Widget>[
                                            Text(FlutterI18n.translate(context,
                                                "msgValidacoesTelaQuebraDeNota.msgErroBuscarComboUsinas")),
                                            Text("${snapshot.error}")
                                          ],
                                        );
                                    }
                                  }),
                            ),
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocContainer.keyComboTipoAcucarQuebraDeNota,
                              child: StreamBuilder<List<TipoAcucar>>(
                                  stream: blocTipoAcucar.outGenericBloc,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return SizedBox();
                                      case ConnectionState.active:
                                        return DropDownFormField.dropDownSugar(
                                            dropDown: DropdownButtonFormField<
                                                TipoAcucar>(
                                              decoration: DropDownFormField
                                                  .decoratorDropDown(),
                                              validator: (TipoAcucar value) {
                                                if (value == null ||
                                                    blocTipoAcucar
                                                        .valueTipoAcucarQuebraDeNota ==
                                                        null) {
                                                  return FlutterI18n.translate(
                                                      context,
                                                      "containerQuebraNota.msgTipoAcucarObrigatorio");
                                                } else {
                                                  return null;
                                                }
                                              },
                                              hint: Text(
                                                  FlutterI18n.translate(context,
                                                      "containerQuebraNota.comboTipoAcucar"),
                                                  style: TextStyle(fontSize: 14)),
                                              value: blocTipoAcucar
                                                  .valueTipoAcucarQuebraDeNota,
                                              onChanged: (TipoAcucar tipoAcucar) {
                                                blocTipoAcucar
                                                    .valueTipoAcucarQuebraDeNota =
                                                    tipoAcucar;
                                                blocTipoAcucar.sinkGenericBloc
                                                    .add(
                                                    blocTipoAcucar.tipoAcucares);
                                                if (snapshotForm.data) {
                                                  blocContainer
                                                      .keyFormInspEstufDesova
                                                      .currentState
                                                      .validate();
                                                }
                                              },
                                              items: snapshot.data
                                                  .map((TipoAcucar tipoAcucar) {
                                                return DropdownMenuItem<
                                                    TipoAcucar>(
                                                  value: tipoAcucar,
                                                  child: Text(
                                                    tipoAcucar.nomeTipoAcucar,
                                                    style: TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                );
                                              }).toList(),
                                            ));
                                      default:
                                        return Row(
                                          children: <Widget>[
                                            Text(FlutterI18n.translate(context,
                                                "msgValidacoesTelaInspecaoEstufagemDesova.msgErroBuscarComboTipoAcucares")),
                                            Text("${snapshot.error}"),
                                          ],
                                        );
                                    }
                                  }),
                            ),

                            _tff.textFormField(
                              _totalDeSacasController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.totalSacas"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 10,
                              maxLines: null,
                              typeText: TextInputType.number,
                              stream: blocContainer.outTotalDeSacas,
                              onChanged: (value) {
                                blocContainer.sinkTotalDeSacas.add(value);
                                if (_totalDeSacasController.text == null ||
                                    _totalDeSacasController.text.isEmpty ||
                                    _totalDeSacasController.text == "" ||
                                    _totalPorContainerController.text == null ||
                                    _totalPorContainerController.text.isEmpty) {
                                  _sobraController.text = "";
                                } else if (_totalPorContainerController.text !=
                                    null &&
                                    _totalPorContainerController
                                        .text.isNotEmpty) {
                                  _sobraController.text = (calculaSobra().toString());
                                      //_totalPorContainerController.numberValue -
                                      //    _totalDeSacasController.numberValue)
                                      //.toStringAsFixed(3);

                                  blocContainer.sinkSobra
                                      .add(_sobraController.text);
                                }
                              },
                            ),

                            _tff.textFormField(
                              _totalPorContainerController,
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.totalPorContainer"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              verificarValidate: true,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: true,
                              maxLength: 10,
                              typeText: TextInputType.number,
                              stream: blocContainer.outTotalPorContainer,
                              onChanged: (value) {
                                blocContainer.sinkTotalPorContainer.add(value);
                                if (_totalDeSacasController.text == null ||
                                    _totalDeSacasController.text.isEmpty ||
                                    _totalDeSacasController.text == "" ||
                                    _totalPorContainerController.text == null ||
                                    _totalPorContainerController.text.isEmpty) {
                                  _sobraController.text = "";
                                } else if (_totalDeSacasController.text != null &&
                                  _totalDeSacasController.text.isNotEmpty) {
                                  _sobraController.text = (calculaSobra().toString());
                                      //_totalPorContainerController.numberValue -
                                      //_totalDeSacasController.numberValue)
                                      //.toStringAsFixed(3);
                                  blocContainer.sinkSobra
                                      .add(_sobraController.text);
                                }
                              },
                            ),

                            _tff.textFormField(
                              _sobraController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.sobra"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              //stsEnabled: false,
                              verificarValidate: false,
                              campoObrigatorio: false,
                              typeText: TextInputType.number,
                              stream: blocContainer.outSobra,
                            ),
                            _tff.textFormField(
                              _avariaController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.avaria"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              campoObrigatorio: true,
                              maxLines: null,
                              isInputFormatters: true,
                              typeText: TextInputType.number,
                              stream: blocContainer.outAvaria,
                              onChanged: (value){
                                blocContainer.changeAvaria;
                                if (_totalDeSacasController.text == null ||
                                    _totalDeSacasController.text.isEmpty ||
                                    _totalDeSacasController.text == "" ||
                                    _totalPorContainerController.text == null ||
                                    _totalPorContainerController.text.isEmpty) {
                                  _sobraController.text = "";
                                } else if (_totalDeSacasController.text != null &&
                                  _totalDeSacasController.text.isNotEmpty) {
                                  _sobraController.text = (calculaSobra().toString());
                                      //_totalPorContainerController.numberValue -
                                      //_totalDeSacasController.numberValue)
                                      //.toStringAsFixed(3);
                                  blocContainer.sinkSobra
                                      .add(_sobraController.text);
                                }
                              },
                            ),
                            _tff.textFormField(
                              _faltaCargaController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.faltaCarga"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              campoObrigatorio: true,
                              isInputFormatters: true,
                              typeText: TextInputType.number,
                              stream: blocContainer.outFaltaCarga,
                              onChanged: (value){
                                blocContainer.changeFaltaCarga;
                                if (_totalDeSacasController.text == null ||
                                    _totalDeSacasController.text.isEmpty ||
                                    _totalDeSacasController.text == "" ||
                                    _totalPorContainerController.text == null ||
                                    _totalPorContainerController.text.isEmpty) {
                                  _sobraController.text = "";
                                } else if (_totalDeSacasController.text != null &&
                                  _totalDeSacasController.text.isNotEmpty) {
                                  _sobraController.text = (calculaSobra().toString());
                                      //_totalPorContainerController.numberValue -
                                      //_totalDeSacasController.numberValue)
                                      //.toStringAsFixed(3);
                                  blocContainer.sinkSobra
                                      .add(_sobraController.text);
                                }
                              },
                            ),
                            _tff.textFormField(
                              _observacaoController,
                              FlutterI18n.translate(
                                  context, "containerQuebraNota.observacao"),
                              FlutterI18n.translate(context,
                                  "containerQuebraNota.msgCampoObrigatorio"),
                              false,
                              campoObrigatorio: false,
                              maxLength: 50,
                              maxLines: null,
                              typeText: TextInputType.multiline,
                              stream: blocContainer.outObservacao,
                              onChanged: blocContainer.changeObservacao,
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<List<QuebraNotasFiscais>>(
                        stream: blocContainer.outListInicialQuebraDeNota,
                        builder: (context, snapshot) {
                          int valor;
                          snapshot.data == null
                              ? valor = 0
                              : valor = snapshot.data.length;
                          return (valor <= 0)
                              ? SizedBox(
                                  height: 70,
                                )
                              : clv.containerListView(
                                  context: context,
                                  tituloContainer: FlutterI18n.translate(context,
                                      "containerQuebraNota.listaTelaQuebraDeNotaDesovaTitulo"),
                                  child: StreamBuilder<List<QuebraNotasFiscais>>(
                                    stream:
                                        blocContainer.outListInicialQuebraDeNota,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.none:
                                          return SizedBox();
                                        case ConnectionState.active:
                                          if (snapshot.data == null ||
                                              snapshot.data.isEmpty) {
                                            return SizedBox();
                                          } else {
                                            return lcqn.lisContainerQuebraDeNota(
                                                context: context,
                                                listQuebraDeNota: snapshot.data);
                                          }
                                          break;
                                        default:
                                          return Row(
                                            children: <Widget>[
                                              Text(FlutterI18n.translate(context,
                                                  "msgValidacoesTelaQuebraDeNota.msgErroBuscarListaQuebraDeNotas")),
                                              Text("${snapshot.error}")
                                            ],
                                          );
                                      }
                                    },
                                  ),
                                );
                        },
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnQuebraNota',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocContainer.inAutoValidateQuebraNota.add(true);
            if (blocContainer.keyFormQuebraNota.currentState.validate() &&
                blocContainer.keyComboUsinaQuebraNota.currentState.validate() &&
                blocContainer.keyComboTipoAcucarQuebraDeNota.currentState
                    .validate() &&
                blocContainer.keyComboNumeroContainer.currentState.validate()) {
              final blocSugar =
                  BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
              blocContainer.sinkSobra.add(_sobraController.text);
              bool sucesso = await blocContainer
                  .salvarQuebraDeNota(blocSugar.valueUUIDFormAtual);
              if (sucesso) {
                blocContainer.inAutoValidateQuebraNota.add(false);
                limparQuebraDeNota();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaQuebraDeNota.msgDadosSalvosComSucesso"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(
                        context, "msgValidacoesTelaQuebraDeNota.msgErroAoSalvar"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaQuebraDeNota.msgCamposObrigatorios"),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  int calculaSobra(){

    var totalSacas = int.parse(_totalDeSacasController.text);
    var totalContainer = int.parse(_totalPorContainerController.text);
    var avaria = int.parse(_avariaController.text == "" ? "0" : _avariaController.text);
    var faltaCarga = int.parse(_faltaCargaController.text == "" ? "0" : _faltaCargaController.text);

    var sobra = totalSacas - totalContainer - avaria - faltaCarga;

    return sobra;

  }

  limparQuebraDeNota() {
    blocUsina.valueQuebraNota = null;
    blocNumeroDoContainer.valueNumeroContainer = null;

    blocNumeroDoContainer.sinkGenericBloc.add(null);
    blocUsina.sinkQuebraNotaBloc.add(blocUsina.usinas);

    blocNumeroDoContainer.valueNumeroContainer = null;
    blocUsina.valueQuebraNota = null;
    _notaFiscalController.text = "";
    _placaController.text = "";
    blocTipoAcucar.valueTipoAcucarQuebraDeNota = null;
    _totalPorContainerController.text = "";
    _totalDeSacasController.text = "";
    _sobraController.text = "";
    _avariaController.text = "";
    _faltaCargaController.text = "";
    _observacaoController.text = "";
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
