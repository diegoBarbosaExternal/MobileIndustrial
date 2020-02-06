import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/models/embarque.dart' as model;
import 'package:sugar/src/ui/widgets/botao_data.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class Embarque extends StatefulWidget {
  @override
  _EmbarqueState createState() => _EmbarqueState();
}

class _EmbarqueState extends State<Embarque>
    with AutomaticKeepAliveClientMixin {

  MyWidget _tff = MyWidget();
  ContainerListView clv = ContainerListView();
  LisContainerEmbarque lce = LisContainerEmbarque();

  model.Embarque embarque = model.Embarque.padrao();

  final blocBreakBulk = BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar =
  BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  final _quantidadeTotalController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);
  final _portoController = TextEditingController();
  final _destinoController = TextEditingController();
  final _inspetorasController = TextEditingController();
  final _dataInicioController = TextEditingController();
  final _dataTerminoController = TextEditingController();
  final _quantSacasController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);
  final _pesoMediaSacaController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);


  @override
  void initState() {
    blocSugar.getEmbarque();
    super.initState();
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
            key: blocBreakBulk.keyFormEmbarque,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: blocBreakBulk.outAutoValidateEmbarque,
                builder: (context, snapshotForm) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            _tff.textFormField(
                              _quantidadeTotalController,
                              FlutterI18n.translate(
                                  context,
                                  "breakbulkEmbarque.quantidadeTotalPeso"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 20,
                              maxLines: null,
                              typeText: TextInputType.number,
                              stream: blocBreakBulk.outQuantidadeTotalPeso,
                              onChanged: (value) {
                                blocBreakBulk.sinkQuantidadeTotalPeso.add(
                                    _quantidadeTotalController.numberValue
                                        .toString());
                              },
                            ),
                            _tff.textFormField(
                              _portoController,
                              FlutterI18n.translate(
                                  context, "breakbulkEmbarque.porto"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 35,
                              maxLines: null,
                              typeText: TextInputType.multiline,
                              stream: blocBreakBulk.outPorto,
                              onChanged: blocBreakBulk.changePorto,
                            ),
                            _tff.textFormField(
                              _destinoController,
                              FlutterI18n.translate(
                                  context, "breakbulkEmbarque.destino"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 25,
                              maxLines: null,
                              typeText: TextInputType.multiline,
                              stream: blocBreakBulk.outDestino,
                              onChanged: blocBreakBulk.changeDestino,
                            ),
                            BotaoData(
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.dataInicioPorto"),
                              campoObrigatorio: true,
                              msgErroValidate: FlutterI18n.translate(
                                  context,
                                  "breakbulkEmbarque.msgDataInicioObrigatorio"),
                              autoValidate: snapshotForm.data,
                              controller: _dataInicioController,
                              stream: blocBreakBulk.outDataInicio,
                              onChanged: blocBreakBulk.changeDataInicio,
                            ),
                            BotaoData(
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.dataTermino"),
                              campoObrigatorio: true,
                              controller: _dataTerminoController,
                              stream: blocBreakBulk.outDataTermino,
                              onChanged: blocBreakBulk.changeDataTermino,
                              msgErroValidate: FlutterI18n.translate(
                                  context,
                                  "breakbulkEmbarque.msgDataTerminoObrigatorio"),
                              autoValidate: snapshotForm.data,
                            ),
                            _tff.textFormField(
                              _inspetorasController,
                              FlutterI18n.translate(
                                  context, "breakbulkEmbarque.inspetoras"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 30,
                              maxLines: null,
                              typeText: TextInputType.multiline,
                              stream: blocBreakBulk.outInspetoras,
                              onChanged: blocBreakBulk.changeInspetoras,
                            ),
                            _tff.textFormField(
                              _quantSacasController,
                              FlutterI18n.translate(
                                  context, "breakbulkEmbarque.quantidadeSacas"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 20,
                              maxLines: null,
                              typeText: TextInputType.number,
                              stream: blocBreakBulk.outQuantidadeSacas,
                                onChanged: (v) {
                                  blocBreakBulk.sinkQuantidadeDeSacas.add(
                                      _quantSacasController.numberValue
                                          .toString());
                                }
                            ),
                            _tff.textFormField(
                              _pesoMediaSacaController,
                              FlutterI18n.translate(
                                  context, "breakbulkEmbarque.pesoMedioSacas"),
                              FlutterI18n.translate(context,
                                  "breakbulkEmbarque.msgCampoObrigatorio"),
                              false,
                              stream: blocBreakBulk.outPesoMedio,
                              onChanged: (value) {
                                blocBreakBulk.sinkPesoMedio.add(
                                    _pesoMediaSacaController.numberValue
                                        .toString());
                              },
                              autoValidate: snapshotForm.data,
                              verificarValidate: true,
                              campoObrigatorio: true,
                              maxLength: 20,
                              maxLines: null,
                              typeText: TextInputType.number,
                            )
                          ],
                        ),
                      ),
                      StreamBuilder<List<model.Embarque>>(
                        stream: blocBreakBulk.outListInicialEmbarque,
                        builder: (context,snapshot){
                          int valor;
                          snapshot.data == null ? valor = 0 : valor = snapshot.data.length;
                          return (valor <= 0) ? SizedBox(height: 70,) : clv.containerListView(
                            context: context,
                            tituloContainer: FlutterI18n.translate(
                                context,
                                "breakbulkEmbarque.listaTelaEmbarqueTitulo"),
                            child: StreamBuilder<List<model.Embarque>>(
                              stream:
                              blocBreakBulk.outListInicialEmbarque,
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
                                      return lce.lisContainerEmbarque(
                                          context: context,
                                          listEmbarque: snapshot.data
                                      );
                                    }
                                    break;
                                  default:
                                    return Row(children: <Widget>[
                                      Text(
                                          FlutterI18n.translate(
                                              context,
                                              "msgValidacoesTelaEmbarque.msgErroBuscarEmbarque")),
                                      Text("${snapshot.error}")
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
          heroTag: 'btnSuperPeso',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocBreakBulk.inAutoValidateEmbarque.add(true);
            if (blocBreakBulk.keyFormEmbarque.currentState.validate()) {
              final blocSugar =
              BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

              bool sucesso =  await blocBreakBulk.salvarEmbarque(blocSugar.valueUUIDFormAtual);
              if(sucesso){
                limparEmbarque();
                blocBreakBulk.inAutoValidateEmbarque.add(false);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(
                        context,
                        "msgValidacoesTelaEmbarque.msgDadosSalvosComSucesso"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
              }else{
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(
                        context,
                        "msgValidacoesTelaEmbarque.msgErroAoSalvar"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            }else{
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  FlutterI18n.translate(
                      context,
                      "msgValidacoesTelaEmbarque.msgCamposObrigatorios"),
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

  limparEmbarque(){
    _portoController.clear();
    _destinoController.clear();
    _dataInicioController.clear();
    _dataTerminoController.clear();
    _inspetorasController.clear();
    _quantSacasController.text = "0.000";
    _quantidadeTotalController.text = "0.000";
    _pesoMediaSacaController.text = "0.000";
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
