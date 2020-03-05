import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/models/dados_container.dart';
import 'package:sugar/src/models/tipo_usina.dart';
import 'package:sugar/src/models/usina.dart';
import 'package:sugar/src/ui/widgets/botao_data.dart';
import 'package:sugar/src/ui/widgets/drop_down_validation.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';

class SupervisaoDePeso extends StatefulWidget {
  @override
  SupervisaoDePesoState createState() => SupervisaoDePesoState();
}

class SupervisaoDePesoState extends State<SupervisaoDePeso>
    with AutomaticKeepAliveClientMixin {
  MyWidget _tff = MyWidget();

  final _marcaDaBalancaController = TextEditingController();
  final _numeroDeSerieController = TextEditingController();
  final _ultimaCalibracaoController = TextEditingController();
  final _numeroDeLacreController = TextEditingController();
  final _mediaController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);

  final _taraDaUnidadeController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);
  final _companhiaController = TextEditingController();
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  final _inkjetController = TextEditingController();

  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
//  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<TipoUsina>();
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  void initState() {
    carregarCampos();
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
          child: StreamBuilder<bool>(
              initialData: false,
              stream: blocContainer.outAutoValidateSupervisaoPeso,
              builder: (context, snapshotForm) {
                return Form(
                  key: blocContainer.keyFormSupervisaoPeso,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            Form(
                              autovalidate: snapshotForm.data,
                              key: blocContainer.keyComboUsinaSupervisaoPeso,
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
                                              "containerSupervisaoDePeso.comboUsinas"),
                                          dropDown:
                                          DropdownButtonFormField<Usina>(
                                            decoration: DropDownFormField
                                                .decoratorDropDown(),
                                            validator: (Usina value) {
                                              if (value == null) {
                                                return FlutterI18n.translate(
                                                    context,
                                                    "containerSupervisaoDePeso.msgUsinaObrigatorio");
                                              } else {
                                                return null;
                                              }
                                            },
                                            hint: Text(
                                                FlutterI18n.translate(context,
                                                    "containerSupervisaoDePeso.comboUsinas"),
                                                style: TextStyle(fontSize: 15)),
                                            value: blocUsina.valueSupervisaoPeso,
                                            onChanged: (Usina usina) {
                                              blocUsina.valueSupervisaoPeso =
                                                  usina;
                                              blocUsina.sinkGenericBloc
                                                  .add(blocUsina.usinas);
                                              if (snapshotForm.data) {
                                                blocContainer
                                                    .keyFormSupervisaoPeso
                                                    .currentState
                                                    .validate();
                                              }
                                            },
                                            items:
                                            snapshot.data.map((Usina usina) {
                                              return DropdownMenuItem<Usina>(
                                                value: usina,
                                                child: Text(
                                                  "${usina.usina}",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      default:
                                        return Text(
                                            'Error ao buscar combo de usinas '
                                            '${snapshot.error}');
                                    }
                                  }),
                            ),
                            _tff.textFormField(
                              _marcaDaBalancaController,
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.marcaBalanca"),
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: false,
                              maxLength: 15,
                              maxLines: null,
                              verificarValidate: false,
                              stream: blocContainer.outMarcaDaBalanca,
                              onChanged: blocContainer.changeMarcaDaBalanca,
                            ),
                            _tff.textFormField(
                              _numeroDeSerieController,
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.numeroSerie"),
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              verificarValidate: false,
                              campoObrigatorio: false,
                              maxLength: 15,
                              maxLines: null,
                              stream: blocContainer.outNumeroDeSerie,
                              onChanged: blocContainer.changNumeroDeSerie,
                            ),
                            _tff.textFormField(
                              _numeroDeLacreController,
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.numeroLacre"),
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: false,
                              maxLength: 10,
                              maxLines: null,
                              typeText: TextInputType.text,
                              verificarValidate: false,
                              stream: blocContainer.outNumeroDeLacre,
                              onChanged: blocContainer.changNumeroDeLacre,
                            ),
                            BotaoData(
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.ultimaCalibracao"),
                                controller: _ultimaCalibracaoController,
                                campoObrigatorio: false,
                                stream: blocContainer.outUltimaCalibracao,
                                autoValidate: snapshotForm.data,
                                onChanged: blocContainer.changeUltimaCalibracao,
//                                msgErroValidate: FlutterI18n.translate(context,
//                                    "containerSupervisaoDePeso.msgUltimaCalibracaoObrigatorio")
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _tff.textFormField(
                              _companhiaController,
                              FlutterI18n.translate(
                                  context, "containerSupervisaoDePeso.companhia"),
                              FlutterI18n.translate(context,
                                  "containerSupervisaoDePeso.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: false,
                              maxLength: 15,
                              maxLines: null,
                              verificarValidate: false,
                              stream: blocContainer.outCompanhia,
                              onChanged: blocContainer.changCompanhia,
                            ),
                            Divider(color: Colors.white),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            gridView(),
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 5),
                              child: StreamBuilder<List<String>>(
                                stream: blocContainer.outListPesoSacas,
                                builder: (context, snapshot) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(FlutterI18n.translate(context,
                                              "containerSupervisaoDePeso.totalKg")),
                                          Text(
                                              "${blocContainer
                                                  .totalPesoSacas()}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(FlutterI18n.translate(context,
                                              "containerSupervisaoDePeso.unidadesPesadas")),
                                          Text(
                                              "${blocContainer
                                                  .unidadesPesadasPesoSacas()}"),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<bool>(
                              stream: blocContainer.outValidatePesoSacas,
                              initialData: false,
                              builder: (context, snapshot) {
                                if (snapshot.data == false) {
                                  return SizedBox();
                                } else {
                                  return Text(
                                    FlutterI18n.translate(context,
                                        "containerSupervisaoDePeso.msgPesoSacasObrigatorio"),
                                    style: TextStyle(color: Colors.red),
                                  );
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => addValor());

                                    blocContainer.sinkValidatePesoSacas
                                        .add(false);
                                  },
                                  color: Color.fromARGB(255, 243, 112, 33),
                                ),
                              ],
                            ),
                            StreamBuilder<List<String>>(
                              stream: blocContainer.outListPesoSacas,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return SizedBox();
                                  case ConnectionState.active:
                                    return _tff.textFormField(
                                      _mediaController,
                                      FlutterI18n.translate(context,
                                          "containerSupervisaoDePeso.media"),
                                      FlutterI18n.translate(context,
                                          "containerSupervisaoDePeso.msgCampoObrigatorio"),
                                      false,
                                      autoValidate: snapshotForm.data,
                                      campoObrigatorio: true,
                                      verificarValidateFuncion: false,
                                      verificarValidate: true,
                                      stream: blocContainer.outMedia,
                                      onChanged: (v) {
                                        blocContainer.changMedia;
                                        blocContainer.sinkTaraDaUnidade.add(
                                            _mediaController.numberValue
                                                .toString());
                                        blocContainer.sinkMedia.add(
                                            _mediaController.numberValue
                                                .toString());
                                      },
                                      typeText: TextInputType.number,
                                    );
                                  default:
                                    return Text(
                                        'Erro ao Digitar Media: ${snapshot.error}');
                                }
                              },
                            ),
                            _tff.textFormField(
                                _taraDaUnidadeController,
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.taraUnidade"),
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                campoObrigatorio: true,
                                verificarValidate: true,
                                typeText: TextInputType.number,
                                stream: blocContainer.outTaraDaUnidade,
                                onChanged: (v) {
                              blocContainer.sinkTaraDaUnidade
                                  .add(_mediaController.numberValue.toString());
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<String>(
                              stream: blocContainer.outTaraDaUnidade,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "containerSupervisaoDePeso.mediaPesoLiquido")),
                                        Text("0.0")
                                      ],
                                    );
                                  case ConnectionState.active:
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "containerSupervisaoDePeso.mediaPesoLiquido"),
                                            style: TextStyle(fontSize: 12)),
                                        Text(
                                            "${snapshot.data != null
                                                ? blocContainer.MediaPesoLiquido(
                                                media: snapshot.data,
                                                tara: _taraDaUnidadeController
                                                    .numberValue == null
                                                    ? "0.0"
                                                    : _taraDaUnidadeController
                                                    .numberValue.toString())
                                                : 0.0}",
                                          style: TextStyle(fontSize: 12),)
                                      ],
                                    );
                                  default:
                                    return Row(
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "msgValidacoesTelaSupervisaoDePeso.msgErroBuscarTaraDaUnidade")),
                                        Text("${snapshot.error}")
                                      ],
                                    );
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 60),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: <Widget>[
                              _tff.textFormField(
                                _frontController,
                                FlutterI18n.translate(
                                    context, "containerSupervisaoDePeso.front"),
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                campoObrigatorio: true,
                                verificarValidate: true,
                                maxLength: 300,
                                maxLines: null,
                                typeText: TextInputType.multiline,
                                stream: blocContainer.outFront,
                                onChanged: blocContainer.changFront,
                              ),
                              _tff.textFormField(
                                _backController,
                                FlutterI18n.translate(
                                    context, "containerSupervisaoDePeso.back"),
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                campoObrigatorio: true,
                                maxLength: 900,
                                maxLines: null,
                                typeText: TextInputType.multiline,
                                stream: blocContainer.outBack,
                                onChanged: blocContainer.changBack,
                              ),
                              _tff.textFormField(
                                _inkjetController,
                                FlutterI18n.translate(
                                    context, "containerSupervisaoDePeso.inkjet"),
                                FlutterI18n.translate(context,
                                    "containerSupervisaoDePeso.msgCampoObrigatorio"),
                                false,
                                autoValidate: snapshotForm.data,
                                verificarValidate: true,
                                campoObrigatorio: true,
                                maxLength: 100,
                                maxLines: null,
                                typeText: TextInputType.multiline,
                                stream: blocContainer.outInkjet,
                                onChanged: blocContainer.changInkjet,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnSuperPeso',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (validateSupervisaoPeso()) {
              blocContainer.sinkTaraDaUnidade.add(
                  _taraDaUnidadeController.numberValue.toString());
              blocContainer.sinkMedia.add(
                  _mediaController.numberValue.toString());
              final blocSugar =
                  BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

              bool sucesso = await blocContainer
                  .salvarSupervisaoDePeso(blocSugar.valueUUIDFormAtual);

              if (sucesso) {
                blocContainer.inAutoValidateSupervisaoPeso.add(false);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaSupervisaoDePeso.msgDadosSalvosComSucesso"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
                blocContainer.sinkTaraDaUnidade.add(_mediaController.text);
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaSupervisaoDePeso.msgErroAoSalvar"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
                blocContainer.sinkTaraDaUnidade.add(_mediaController.text);
              }
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaSupervisaoDePeso.msgCamposObrigatorios"),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.red,
              ));
              blocContainer.sinkTaraDaUnidade.add(_mediaController.text);
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

  bool validateSupervisaoPeso() {

    bool validatePesoSacas = blocContainer.validatePesoSacas();
    if (validatePesoSacas) {
      blocContainer.sinkValidatePesoSacas.add(true);
    }
    if (blocContainer.keyFormSupervisaoPeso.currentState.validate() &&
        !validatePesoSacas &&
        blocContainer.keyComboUsinaSupervisaoPeso.currentState.validate()) {
      return true;
    } else {
      blocContainer.inAutoValidateSupervisaoPeso.add(true);
      return false;
    }
  }

  carregarCampos() async {
    DadosContainer dados;
    dados = await blocSugar.getDadosContainer();

    if (dados != null) {
      if (dados.usinaSP != null) {
        blocUsina.valueSupervisaoPeso = dados.usinaSP;
        blocUsina.sinkGenericBloc.add(blocUsina.usinas);
      }
      if (dados.marcaDaBalanca != null) {
        _marcaDaBalancaController.text = dados.marcaDaBalanca;
        blocContainer.inMarcaBalanca.add(dados.marcaDaBalanca);
      }
      if (dados.numeroDeSerie != null) {
        _numeroDeSerieController.text = dados.numeroDeSerie;
        blocContainer.inNumeroDeSerie.add(dados.numeroDeSerie);
      }
      if (dados.numeroDoLacre != null) {
        _numeroDeLacreController.text = dados.numeroDoLacre;
        blocContainer.inNumeroDeLacre.add(dados.numeroDoLacre);
      }
      if (dados.ultimaCalibracao != null) {
        String dataCalibracao = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(dados.ultimaCalibracao));
        _ultimaCalibracaoController.text = dataCalibracao;
        blocContainer.inUltimaCalibracao
            .add(DateTime.parse(dados.ultimaCalibracao));
      }
      if (dados.companhia != null) {
        _companhiaController.text = dados.companhia;
        blocContainer.inCompanhia.add(dados.companhia);
      }

      if (dados.pesoSacas != null) {
        List<String> listPesoSacas =
        ContainerBloc.convertDoubleToString(dados.pesoSacas);
        blocContainer.sinkPesoSacas.add(listPesoSacas);
        blocContainer.sinkTaraDaUnidade.add(blocContainer.valueMedia);

        if (dados.media != null) {
          _mediaController.text = dados.media.toString();
          blocContainer.sinkMedia.add(dados.media.toString());
        }

        if (dados.taraDaUnidade != null) {
          _taraDaUnidadeController.text = dados.taraDaUnidade.toString();
          blocContainer.sinkTaraDaUnidade.add(dados.taraDaUnidade.toString());
        }
        blocContainer.sinkTaraDaUnidade.add(_mediaController.text);

        listPesoSacas.forEach((pesoSaca) {
          blocContainer.listAuxPesoSacas.add(pesoSaca);
        });

        blocContainer.unidadesPesadasPesoSacas();
      }
      if (dados.front != null) {
        _frontController.text = dados.front;
        blocContainer.inFront.add(dados.front);
      }
      if (dados.back != null) {
        _backController.text = dados.back;
        blocContainer.inBack.add(dados.back);
      }
      if (dados.inkjet != null) {
        _inkjetController.text = dados.inkjet;
        blocContainer.inInkjet.add(dados.inkjet);
      }
    }
  }

  Widget addValor() {
    MoneyMaskedTextController _valorController = MoneyMaskedTextController(
        decimalSeparator: '.', thousandSeparator: ',', precision: 3);

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _tff.textFormField(
              _valorController,
              FlutterI18n.translate(
                  context, "msgValidacoesTelaSupervisaoDePeso.msgCampoValor"),
              FlutterI18n.translate(context,
                  "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
              false,
              autoValidate: false,
              maxLength: 19,
              campoObrigatorio: true,
              maxLines: null,
              typeText: TextInputType.number,
            ),
            FlatButton(
              child: Text(
                FlutterI18n.translate(context,
                    "msgValidacoesTelaSupervisaoDePeso.msgCampoAdicionar"),
                style: TextStyle(color: Colors.white),
              ),
              color: Color.fromARGB(255, 243, 112, 33),
              onPressed: () {
                if (_valorController.text.isNotEmpty &&
                    _valorController.text != "0.000") {
                  blocContainer.listAuxPesoSacas.add(
                      _valorController.numberValue.toString());
                  blocContainer.sinkPesoSacas
                      .add(blocContainer.listAuxPesoSacas);
                  blocContainer.sinkTaraDaUnidade.add(blocContainer.valueMedia);
                  _mediaController.text = blocContainer.valueMedia;
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget gridView() {
    final blocContainer =
        BlocProvider.tag('container').getBloc<ContainerBloc>();
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        richText(
            FlutterI18n.translate(
                context, "containerSupervisaoDePeso.pesoSacas"),
            CdQPdS: true),
        Container(
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
          //height: 75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: Color.fromARGB(255, 243, 112, 33), width: 1)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                border: Border.all(
                    color: Colors.green.withOpacity(0.5), width: 0.1)),
            height: 120,
            child: StreamBuilder<List<String>>(
                stream: blocContainer.outListPesoSacas,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.active:
                      return (snapshot.data != null && snapshot.data.length > 0)
                          ? GridView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(10.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onLongPress: () {
                                      blocContainer.listAuxPesoSacas
                                          .removeAt(index);
                                      blocContainer.sinkPesoSacas
                                          .add(blocContainer.listAuxPesoSacas);
                                      blocContainer.sinkTaraDaUnidade
                                          .add(blocContainer.valueMedia);
                                      if (blocContainer.valueMedia == null ||
                                          blocContainer.valueMedia.isEmpty ||
                                          blocContainer.valueMedia == "0.000") {
                                        _mediaController.text = "0.000";
                                      } else {
                                        _mediaController.text =
                                            blocContainer.valueMedia;
                                      }
                                      bool validatePesoSacas =
                                          blocContainer.validatePesoSacas();
                                      if (validatePesoSacas) {
                                        blocContainer.sinkValidatePesoSacas
                                            .add(true);
                                      } else {
                                        blocContainer.sinkValidatePesoSacas
                                            .add(false);
                                      }
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 75,
                                      margin: EdgeInsets.only(
                                          left: 2.5, right: 2.5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 243, 112, 33),
                                              width: 1)),
                                      alignment: Alignment.center,
                                      child: Text(snapshot.data[index]),
                                    ));
                              })
                          : Container();
                    default:
                      return Row(
                        children: <Widget>[
                          Text(FlutterI18n.translate(context,
                              "msgValidacoesTelaSupervisaoDePeso.msgErroAoBuscarPesoSacas")),
                          Text("${snapshot.error}")
                        ],
                      );
                  }
                }),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

Widget richText(String texto, {bool CdQPdS = false}) {
  return RichText(
    text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: texto,
          style: CdQPdS == true
              ? TextStyle(fontSize: 14, color: Colors.black)
              : TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
      TextSpan(
          text: "*",
          style: CdQPdS == true
              ? TextStyle(fontSize: 14, color: Colors.red)
              : TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
    ]),
  );
}
