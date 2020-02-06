import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/models/time_logs.dart' as modelTimeLogs;
import 'package:sugar/src/ui/widgets/botao_data.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class TimeLogs extends StatefulWidget {
  @override
  _TimeLogsState createState() => _TimeLogsState();
}

class _TimeLogsState extends State<TimeLogs>
    with AutomaticKeepAliveClientMixin {

  LisContainerTimeLogs lctl = LisContainerTimeLogs();

  final blocTP =
  BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();

  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  var blocSugarTP;

  MyWidget _tff = MyWidget();
  ContainerListView clv = ContainerListView();

  final _selecionarDataInicioController = TextEditingController();
  final _selecionarDataTerminoController = TextEditingController();

  final _ocorrenciaController = TextEditingController();

  @override
  void initState() {
    blocTP.getTipo() == 1
        ? blocSugarTP = BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>()
        : blocSugarTP = BlocProvider.tag('container').getBloc<ContainerBloc>();

    blocSugar.getTimeLogs(blocTP.getTipo());

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
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: blocSugarTP.keyFormGlobalKeyTimeLogs,
              child: Column(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(top: 10),
                    elevation: 5,
                    child: StreamBuilder<bool>(
                        initialData: false,
                        stream: blocSugarTP.outAutoValidateTimeLogs,
                        builder: (context, snapshotForm) {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              BotaoDataHora(
                                FlutterI18n.translate(
                                    context, "timeLogs.selecionarDataInicio"),
                                controller: _selecionarDataInicioController,
                                campoObrigatorio: true,
                                stream: blocSugarTP.outSelecionarInicioData,
                                autoValidate: snapshotForm.data,
                                onChanged: blocSugarTP.changeSelecionarDataInicio,
                                msgErro: FlutterI18n.translate(
                                    context, "timeLogs.msgDataInicioObrigatorio"),
                              ),
                              BotaoDataHora(
                                FlutterI18n.translate(
                                    context, "timeLogs.selecionarDataTermino"),
                                controller: _selecionarDataTerminoController,
                                campoObrigatorio: true,
                                stream: blocSugarTP.outSelecionarTerminoData,
                                autoValidate: snapshotForm.data,
                                onChanged: blocSugarTP
                                    .changeSelecionarTerminoData,
                                msgErro: FlutterI18n.translate(
                                    context,
                                    "timeLogs.msgDataTerminoObrigatorio"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _tff.textFormField(
                                  _ocorrenciaController, FlutterI18n.translate(
                                  context, "timeLogs.ocorrencia"),
                                  FlutterI18n.translate(
                                      context, "timeLogs.msgCampoObrigatorio"),
                                  false,
                                  campoObrigatorio: false,
                                  maxLength: 150,
                                  maxLines: null,
                                  typeText: TextInputType.multiline,
                                  stream: blocSugarTP.outOcorrencia,
                                  onChanged: blocSugarTP.changeOcorrencia),
                            ],
                          );
                        }
                    ),
                  ),
                  StreamBuilder<List<modelTimeLogs.TimeLogs>>(
                    stream: blocSugarTP.outListInicialTimeLogs,
                    builder: (context,snapshot){
                      int valor;
                      snapshot.data == null ? valor = 0 : valor = snapshot.data.length;
                      return (valor <= 0) ? SizedBox(height: 70,) :  clv.containerListView(
                          context: context,
                          tituloContainer: FlutterI18n.translate(
                              context, "timeLogs.listaTelaTimeLogsTitulo"),

                          child: StreamBuilder<List<modelTimeLogs.TimeLogs>>(
                            stream: blocSugarTP.outListInicialTimeLogs,
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
                                    return lctl.lisContainerTimeLogs(
                                        context: context,
                                        listTL: snapshot.data
                                    );
                                  }
                                  break;
                                default:
                                  return Row(children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaTimeLogs.msgErroBuscarTimeLogs")),
                                    Text("${snapshot.error}")
                                  ],);
                              }
                            },
                          )

                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnTimeLogs',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocSugarTP.inAutoValidateTimeLogs.add(true);

            if (blocSugarTP.keyFormGlobalKeyTimeLogs.currentState.validate()) {
              final blocSugar =
              BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

              bool sucesso = await blocSugarTP.salvarTimeLogs(blocSugar.valueUUIDFormAtual);
              if(sucesso){
                limparTimeLogs();
                blocSugarTP.inAutoValidateTimeLogs.add(false);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(FlutterI18n.translate(context,
                      "msgValidacoesTelaTimeLogs.msgDadosSalvosComSucesso"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
              }else{
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaTimeLogs.msgErroAoSalvar"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            }
            else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaTimeLogs.msgCamposObrigatorios"),
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

  limparTimeLogs() {
    _selecionarDataInicioController.text = "";
    _selecionarDataTerminoController.text = "";
    _ocorrenciaController.text = "";
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
