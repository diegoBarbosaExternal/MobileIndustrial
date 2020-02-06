import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/turno_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/recebimento.dart' as modelRecebimento;
import 'package:sugar/src/models/tipo_usina.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/drop_down_validation.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';

class Recebimento extends StatefulWidget {
  @override
  _RecebimentoState createState() => _RecebimentoState();
}

class _RecebimentoState extends State<Recebimento>
    with AutomaticKeepAliveClientMixin {
  MyWidget _tff = MyWidget();
  ContainerListView clv = ContainerListView();
  LisContainerRecebimento lcr = LisContainerRecebimento();

  final _analiseDeProdutoController = TextEditingController();
  final _resultadoController = TextEditingController();
  final _nCaminhoesDaCompostaController = TextEditingController();

  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
  final blocTipoUsina =
      BlocProvider.tag('sugarGlobal').getBloc<TipoUsinaBloc>();
  final blocTurno = BlocProvider.tag('sugarGlobal').getBloc<DropDowBlocTurno>();
  final blocRecebimento =
      BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  List<String> _turnos;

  @override
  void initState() {
    _turnos = blocTurno.getTurnos();
    blocSugar.getRecebimento();
    super.initState();
  }

  @override
  void dispose() {
    blocUsina.valueRecebimento = null;
    blocTipoUsina.valueTipoUsina = null;
    blocTurno.valueTurno = null;
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
            key: blocRecebimento.keyFormRecebimento,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: blocRecebimento.outAutoValidateRecebimento,
                builder: (context, snapshotForm) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocRecebimento.keyComboTipoUsina,
                              child: StreamBuilder<List<TipoUsina>>(
                                  stream: blocTipoUsina.outGenericBloc,
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return SizedBox();
                                      case ConnectionState.active:
                                        return DropDownFormField.dropDownSugar(
                                          hint: FlutterI18n.translate(context,
                                              "breakbulkRecebimento.comboTipoUsina"),
                                          dropDown:
                                              DropdownButtonFormField<TipoUsina>(
                                            validator: (TipoUsina value) {
                                              if (value == null ||
                                                  blocTipoUsina.valueTipoUsina ==
                                                      null) {
                                                return FlutterI18n.translate(
                                                    context,
                                                    "breakbulkRecebimento.msgComboTipoUsinaObrigatorio");
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: DropDownFormField
                                                .decoratorDropDown(),
                                                hint: Text(
                                                  FlutterI18n.translate(context,
                                                      "breakbulkRecebimento.comboTipoUsina"),
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                            value: blocTipoUsina.valueTipoUsina,
                                            onChanged: (TipoUsina tipoUsina) {
                                              blocTipoUsina.valueTipoUsina =
                                                  tipoUsina;
                                              blocTipoUsina.sinkGenericBloc
                                                  .add(blocTipoUsina.tipoUsinas);
                                              if (snapshotForm.data) {
                                                blocRecebimento.keyFormRecebimento
                                                    .currentState
                                                    .validate();
                                              }
                                              blocUsina.sinkGenericBloc
                                                  .add(blocUsina.usinas);
                                            },
                                            items: snapshot.data
                                                .map((TipoUsina tipoUsina) {
                                              return DropdownMenuItem<TipoUsina>(
                                                value: tipoUsina,
                                                child: Text(
                                                  tipoUsina.nomeTipoUsina,
                                                  style: TextStyle(fontSize: 13),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      default:
                                        return Text(
                                            'Error ao buscar combo de tipo usinas: '
                                            '${snapshot.error}');
                                    }
                                  }),
                            ),
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocRecebimento.keyComboUsinaRecebimento,
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
                                                "breakbulkRecebimento.comboUsina"),
                                            dropDown: blocTipoUsina
                                                        .valueTipoUsina !=
                                                    null
                                                ? DropdownButtonFormField<Usina>(
                                                    validator: (Usina value) {
                                                      if (value == null ||
                                                          blocUsina
                                                                  .valueRecebimento ==
                                                              null) {
                                                        return FlutterI18n.translate(
                                                            context,
                                                            "breakbulkRecebimento.msgComboUsinaObrigatorio");
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: DropDownFormField
                                                        .decoratorDropDown(),
                                                    hint: Text(FlutterI18n.translate(
                                                        context,
                                                        "breakbulkRecebimento.comboUsina")),
                                                    value: blocUsina
                                                        .valueRecebimento,
                                                    onChanged: (Usina usina) {
                                                      blocUsina.valueRecebimento =
                                                          usina;
                                                      blocUsina.sinkGenericBloc
                                                          .add(blocUsina.usinas);
                                                      if (snapshotForm.data) {
                                                        blocRecebimento
                                                            .keyFormRecebimento
                                                            .currentState
                                                            .validate();
                                                      }
                                                    },
                                                    items: snapshot.data
                                                        .map((Usina usina) {
                                                      return DropdownMenuItem<
                                                          Usina>(
                                                        value: usina,
                                                        child: Text(
                                                          usina.usina,
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                : SizedBox());
                                      default:
                                        return Text(
                                            'Error ao buscar combo de usinas: '
                                            '${snapshot.error}');
                                    }
                                  }),
                            ),
                            _tff.textFormField(
                              _analiseDeProdutoController,
                              FlutterI18n.translate(
                                  context, "breakbulkRecebimento.analiseProduto"),
                              FlutterI18n.translate(context,
                                  "breakbulkRecebimento.msgCampoObrigatorio"),
                              false,
                              campoObrigatorio: false,
                              maxLength: 25,
                              typeText: TextInputType.text,
                              stream: blocRecebimento.outAnaliseDeProduto,
                              onChanged: blocRecebimento.changeAnaliseDeProduto,
                            ),
                            _tff.textFormField(
                              _resultadoController,
                              FlutterI18n.translate(
                                  context, "breakbulkRecebimento.resultado"),
                              FlutterI18n.translate(context,
                                  "breakbulkRecebimento.msgCampoObrigatorio"),
                              false,
                              campoObrigatorio: false,
                              maxLength: 150,
                              maxLines: null,
                              typeText: TextInputType.multiline,
                              stream: blocRecebimento.outResultado,
                              onChanged: blocRecebimento.changeResultado,
                            ),
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocRecebimento.keyComboTurno,
                              child: StreamBuilder<String>(
                                  initialData: '',
                                  stream: blocTurno.outGenericBloc,
                                  builder: (context, snapshot) {
                                    return DropDownFormField.dropDownSugar(
                                      hint: FlutterI18n.translate(context,
                                          "breakbulkRecebimento.comboTurno"),
                                      dropDown: DropdownButtonFormField<String>(
                                        validator: (String value) {
                                          if (value == null ||
                                              blocTurno.valueTurno == null) {
                                            return FlutterI18n.translate(context,
                                                "breakbulkRecebimento.msgComboTurnoObrigatorio");
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration:
                                            DropDownFormField.decoratorDropDown(),
                                        hint: Text(FlutterI18n.translate(context,
                                            "breakbulkRecebimento.comboTurno")),
                                        value: blocTurno.valueTurno,
                                        onChanged: (String value) {
                                          blocTurno.valueTurno = value;
                                          blocTurno.sinkGenericBloc.add(value);
                                          if (snapshotForm.data) {
                                            blocRecebimento
                                                .keyFormRecebimento.currentState
                                                .validate();
                                          }
                                        },
                                        items: _turnos.map((String value) {
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: _tff.textFormField(
                                _nCaminhoesDaCompostaController,
                                FlutterI18n.translate(context,
                                    "breakbulkRecebimento.numeroCaminhoesComposta"),
                                FlutterI18n.translate(context,
                                    "breakbulkRecebimento.msgCampoObrigatorio"),
                                false,
                                verificarValidate: true,
                                campoObrigatorio: true,
                                maxLength: 5,
                                isInputFormatters: true,
                                typeText: TextInputType.number,
                                autoValidate: snapshotForm.data,
                                stream:
                                    blocRecebimento.outNumeroCaminhoesComposta,
                                onChanged:
                                    blocRecebimento.changeNumeroCaminhoesComposta,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<List<modelRecebimento.Recebimento>>(
                        stream: blocRecebimento.outListInicialRecebimento,
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
                                      "breakbulkRecebimento.listaTelaRecebimentoTitulo"),
                                  child: StreamBuilder<
                                      List<modelRecebimento.Recebimento>>(
                                    stream:
                                        blocRecebimento.outListInicialRecebimento,
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
                                            return lcr.lisContainerRecebimento(
                                                context: context,
                                                listRecebimento: snapshot.data);
                                          }
                                          break;
                                        default:
                                          return Row(
                                            children: <Widget>[
                                              Text(FlutterI18n.translate(context,
                                                  "msgValidacoesTelaRecebimento.msgErroBuscarRecebimento")),
                                              Text("${snapshot.error}")
                                            ],
                                          );
                                      }
                                    },
                                  ),
                                );
                        },
                      ),
                      SizedBox(height: 80.0,)
                    ],
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnInspEstuDeso',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocRecebimento.inAutoValidateRecebimento.add(true);
            if (blocRecebimento.keyFormRecebimento.currentState.validate() &&
                blocRecebimento.keyComboTipoUsina.currentState.validate() &&
                blocRecebimento.keyComboTurno.currentState.validate() &&
                blocRecebimento.keyComboUsinaRecebimento.currentState
                    .validate()) {
              final blocSugar =
                  BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
              bool sucesso = await blocRecebimento
                  .salvarRecebimento(blocSugar.valueUUIDFormAtual);
              if (sucesso) {
                limparRecebimento();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaRecebimento.msgDadosSalvosComSucesso"),
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
                        context, "msgValidacoesTelaRecebimento.msgErroAoSalvar"),
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
                      "msgValidacoesTelaRecebimento.msgCamposObrigatorios"),
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

  limparRecebimento() {
    blocUsina.valueRecebimento = null;
    blocTipoUsina.valueTipoUsina = null;
    blocTurno.valueTurno = null;

    blocTipoUsina.sinkGenericBloc.add(blocTipoUsina.tipoUsinas);
    blocUsina.sinkGenericBloc.add(blocUsina.usinas);
    blocTurno.sinkGenericBloc.add(null);

    _analiseDeProdutoController.clear();
    blocRecebimento.inAnaliseProdutoBloc.add("");
    _resultadoController.clear();
    _nCaminhoesDaCompostaController.clear();

    blocRecebimento.inAutoValidateRecebimento.add(false);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
