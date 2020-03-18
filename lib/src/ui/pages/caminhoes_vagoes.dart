import 'dart:io';
import 'package:camera/camera.dart';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/models/caminhoes_vagoes.dart' as modelCaminhoesVagoes;
import 'package:sugar/src/models/dados_breakbulk.dart';
import 'package:sugar/src/ui/widgets/check_box.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class CaminhoesVagoes extends StatefulWidget {
  @override
  _CaminhoesVagoesState createState() => _CaminhoesVagoesState();
}

class _CaminhoesVagoesState extends State<CaminhoesVagoes>
    with AutomaticKeepAliveClientMixin {
  LisContainerCaminhoesVagoes lccv = LisContainerCaminhoesVagoes();

  final blocCaminhoesVagoes =
  BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();

  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  MyWidget _tff = MyWidget();
  CheckBox _checkBox = CheckBox();
  ContainerListView clv = ContainerListView();

  final _caminhaoVagaoController = TextEditingController();
  final _notaFiscalController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _faltasController = TextEditingController();
  final _sobrasController = TextEditingController();
  final _unidadesController = TextEditingController();
  final _resumoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _quantidadeSacasRecebController = TextEditingController();
  final _pesoNotaController = TextEditingController();
  final _placaController = TextEditingController();

  @override
  void initState() {
    blocSugar.getCaminhoesVagoes();
    carregarCampos();
    super.initState();
  }

  File imgArquivo;

  cameraAbrirGaleria() async{

  }

  cameraAbrirCamera(){

  }

  Future<void> cameraExibeOpcoes(BuildContext context){
    return showDialog<void>(
    context: context,
    builder: (BuildContext context){
    return AlertDialog(
    title: Text('Selecione uma fonte'),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          GestureDetector(
            child: Text("Galeria"),
            onTap: (){
              cameraAbrirGaleria();

            },
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          GestureDetector(
            child: Text("Câmera"),
            onTap: (){
              cameraAbrirCamera();
            },
          ),
        ],
      ),
    ),
    actions: <Widget>[
    FlatButton(
    child: Text('Continuar'),
    onPressed: () {
    //Navigator.of(dialogContext).pop(); // Dismiss alert dialog
    },
    ),
    ],
    );
    },
    );
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
            key: blocCaminhoesVagoes.keyFormCaminhoesVagoes,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: blocCaminhoesVagoes.outAutoValidateCaminhoesVagoes,
                builder: (context, snapshotForm) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            _tff.textFormField(_caminhaoVagaoController,
                                FlutterI18n.translate(
                                    context,
                                    "breakbulkCaminhoesVagoes.caminhoesVagoes"),
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                false,
                                stream: blocCaminhoesVagoes.outCaminhoesVagoes,
                                onChanged:
                                blocCaminhoesVagoes.changeCaminhoesVagoes,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                campoObrigatorio: true,
                                maxLength: 50,
                                maxLines: null,
                                typeText: TextInputType.multiline),
                            _tff.textFormField(//TODO Incluir nos arquivos de tradução / Implementar
                              _placaController,
                              FlutterI18n.translate(
                                  context, "breakbulkCaminhoesVagoes.placa"),
                              FlutterI18n.translate(context,
                                  "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 7,
                              typeText: TextInputType.text,
                              stream: blocCaminhoesVagoes.outPlaca,
                              onChanged: blocCaminhoesVagoes.changePlaca,
                            ),
                            _tff.textFormField(//TODO Incluir nos arquivos de tradução / Implementar
                                _pesoNotaController,
                                FlutterI18n.translate(
                                    context, "breakbulkCaminhoesVagoes.pesoNota"),
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                campoObrigatorio: true,
                                maxLength: 20,
                                isInputFormatters: true,
                                typeText: TextInputType.number,
                                stream: blocCaminhoesVagoes.outPesoNota,
                                onChanged: blocCaminhoesVagoes.changePesoNota,
                                verificarValidate: true),
                            _tff.textFormField(
                              _notaFiscalController,
                              FlutterI18n.translate(
                                  context, "breakbulkCaminhoesVagoes.notaFiscal"),
                              FlutterI18n.translate(context,
                                  "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 20,
                              typeText: TextInputType.text,
                              stream: blocCaminhoesVagoes.outNotaFiscal,
                              onChanged: blocCaminhoesVagoes.changeNotaFiscal,
                            ),
//                            _tff.textFormField(//TODO Incluir nos arquivos de tradução / Implementar
//                              _quantidadeSacasRecebController,
//                              FlutterI18n.translate(
//                                  context, "breakbulkCaminhoesVagoes.quantidadeSacas"),
//                              FlutterI18n.translate(context,
//                                  "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
//                              false,
//                              autoValidate: snapshotForm.data,
//                              verificarValidate: true,
//                              campoObrigatorio: true,
//                              maxLength: 7,
//                              typeText: TextInputType.text,
//                              stream: blocCaminhoesVagoes.outQuantidadeSacasReceb,
//                              onChanged: blocCaminhoesVagoes.changeQuantidadeSacasReceb,
//                            ),
                            _tff.textFormField(_quantidadeController,
                                FlutterI18n.translate(
                                    context,
                                    "breakbulkCaminhoesVagoes.quantidadeSacas"),
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                false,
                                stream: blocCaminhoesVagoes.outQuantidade,
                                onChanged: blocCaminhoesVagoes.changeQuantidade,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                isInputFormatters: true,
                                campoObrigatorio: true,
                                maxLength: 20,
                                typeText: TextInputType.number),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "breakbulkCaminhoesVagoes.avarias"),
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    _checkBox.checkBox(
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.molhadas"), (
                                        s) {
                                      blocCaminhoesVagoes.sinkMolhadas.add(s);
                                    }, stream: blocCaminhoesVagoes.outMolhadas),
                                    _checkBox.checkBox(
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.rasgadas"), (
                                        s) {
                                      blocCaminhoesVagoes.sinkRasgadas.add(s);
                                    }, stream: blocCaminhoesVagoes.outRasgadas),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    _checkBox.checkBox(
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.sujas"), (
                                        s) {
                                      blocCaminhoesVagoes.sinkSujas.add(s);
                                    }, stream: blocCaminhoesVagoes.outSujas),
                                    _checkBox.checkBox(
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.empedradas"), (
                                        s) {
                                      blocCaminhoesVagoes.sinkEmpedradas.add(s);
                                    }, stream: blocCaminhoesVagoes.outEmpedradas),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: _tff.textFormField(_faltasController,
                                        FlutterI18n.translate(
                                            context,
                                            "breakbulkCaminhoesVagoes.faltas"),
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                        false,
                                        typeText: TextInputType.number,
                                        campoObrigatorio: false,
                                        isInputFormatters: true,
                                        maxLength: 5,
                                        stream: blocCaminhoesVagoes.outFaltas,
                                        onChanged:
                                        blocCaminhoesVagoes.changeFaltas)),
                                Expanded(
                                    child: _tff.textFormField(_sobrasController,
                                        FlutterI18n.translate(
                                            context,
                                            "breakbulkCaminhoesVagoes.sobras"),
                                        FlutterI18n.translate(context,
                                            "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                        false,
                                        typeText: TextInputType.number,
                                        campoObrigatorio: false,
                                        maxLength: 5,
                                        isInputFormatters: true,
                                        stream: blocCaminhoesVagoes.outSobras,
                                        onChanged:
                                        blocCaminhoesVagoes.changeSobras)),
                              ],
                            ),
                            _tff.textFormField(_unidadesController,
                                FlutterI18n.translate(
                                    context,
                                    "breakbulkCaminhoesVagoes.totalUnidades"),
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                typeText: TextInputType.number,
                                campoObrigatorio: true,
                                isInputFormatters: true,
                                maxLength: 5,
                                stream: blocCaminhoesVagoes.outTotalUnidades,
                                onChanged:
                                blocCaminhoesVagoes.changeTotalUnidades),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    FlutterI18n.translate(context,
                                        "breakbulkCaminhoesVagoes.observacao"),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  _tff.textFormField(_observacaoController, "",
                                      FlutterI18n.translate(context,
                                          "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                      false,
                                      stream: blocCaminhoesVagoes.outObservacao,
                                      onChanged:
                                      blocCaminhoesVagoes.changeObservacao,
                                      campoObrigatorio: false,
                                      maxLength: 250,
                                      maxLines: null,
                                      typeText: TextInputType.multiline),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(top: 20),
                        elevation: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "breakbulkCaminhoesVagoes.resumo"),
                                  style: TextStyle(fontSize: 16),
                                )),
                            _tff.textFormField(
                                _resumoController, "", FlutterI18n.translate(
                                context,
                                "breakbulkCaminhoesVagoes.msgCampoObrigatorio"),
                                false,
                                stream: blocCaminhoesVagoes.outResumo,
                                onChanged: blocCaminhoesVagoes.changeResumo,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                campoObrigatorio: true,
                                maxLength: 250,
                                maxLines: null,
                                typeText: TextInputType.multiline),
                            Center(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text("Nenhuma imagem selecionada!"),
                                RaisedButton(onPressed: (){
                                  cameraExibeOpcoes(context);
                                },
                                  child: Text("Selecionar imagem"),
                                )
                              ],
                            ),
                            ),


                          ],
                        ),
                      ),
                      StreamBuilder<List<modelCaminhoesVagoes.CaminhoesVagoes>>(
                        stream:  blocCaminhoesVagoes.outListBreakBulkCaminhoesVagoes,
                        builder: (context,snapshot){
                          int valor;
                          snapshot.data == null ? valor = 0 : valor = snapshot.data.length;
                          return (valor <= 0) ? SizedBox(height: 70,) : clv.containerListView(
                            context: context,
                            tituloContainer: FlutterI18n.translate(context, "breakbulkCaminhoesVagoes.caminhoesVagoes"),
                            child: StreamBuilder<
                                List<modelCaminhoesVagoes.CaminhoesVagoes>>(
                              stream:
                              blocCaminhoesVagoes.outListBreakBulkCaminhoesVagoes,
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
                                      return lccv.lisContainerCaminhoesVagoes(
                                          context: context, listCV: snapshot.data
                                      );
                                    }
                                    break;
                                  default:
                                    return Row(children: <Widget>[
                                      Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaCaminhoesVagoes.msgErroBuscarCaminhoesVagoes"),),
                                      Text('${snapshot.error}'),
                                    ],);
                                }
                              },
                            ),
                          );
                        },
                      )
                    ],
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnCaminhaoVagoes',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocCaminhoesVagoes.inAutoValidateCaminhoesVagoes.add(true);
            if (blocCaminhoesVagoes.keyFormCaminhoesVagoes.currentState
                .validate()) {
              final blocSugar =
              BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

              bool sucesso = await blocCaminhoesVagoes
                  .salvarCaminhoesVagoes(blocSugar.valueUUIDFormAtual);
              if (sucesso) {
                limparCaminhoesVagoes();
                blocCaminhoesVagoes.inAutoValidateCaminhoesVagoes.add(false);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaCaminhoesVagoes.msgDadosSalvosComSucesso"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaCaminhoesVagoes.msgErroAoSalvar"),
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
                      "msgValidacoesTelaCaminhoesVagoes.msgCamposObrigatorios"),
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

  limparCaminhoesVagoes() {
    _caminhaoVagaoController.text = "";
    _notaFiscalController.text = "";
    _quantidadeController.text = "";
    blocCaminhoesVagoes.sinkMolhadas.add(false);
    blocCaminhoesVagoes.sinkRasgadas.add(false);
    blocCaminhoesVagoes.sinkSujas.add(false);
    blocCaminhoesVagoes.sinkEmpedradas.add(false);
    _faltasController.text = "";
    _sobrasController.text = "";
    _unidadesController.text = "";
    _observacaoController.text = "";
    _resumoController.clear();
  }

  carregarCampos() async {
    DadosBreakBulk dados;
    dados = await blocSugar.getDadosBreakBulk();

    if (dados != null) {
      _resumoController.text = dados.resumo;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}