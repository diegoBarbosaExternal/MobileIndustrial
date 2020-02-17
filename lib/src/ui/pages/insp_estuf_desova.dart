import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/numero_container_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/models/dados_container.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/models/inf_container.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/ui/widgets/botao_data.dart';
import 'package:sugar/src/ui/widgets/check_box.dart';
import 'package:sugar/src/ui/widgets/container_listview.dart';
import 'package:sugar/src/ui/widgets/drop_down_validation.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/list_formulario.dart';


class InspecaoEstufagemDesova extends StatefulWidget {
  @override
  InspecaoEstufagemDesovaState createState() => InspecaoEstufagemDesovaState();
}

class InspecaoEstufagemDesovaState extends State<InspecaoEstufagemDesova>
    with AutomaticKeepAliveClientMixin {
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocNumeroDoContainer =
  BlocProvider.tag('container').getBloc<DropDowBlocNumeroDoContainer>();

  MyWidget _tff = MyWidget();
  CheckBox _checkBox = CheckBox();
  ContainerListView clv = ContainerListView();
  LisContainerInspecaoEstufagemDesova lcied =
  LisContainerInspecaoEstufagemDesova();

  final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  final _matriculaController = TextEditingController();
  final _ordemServicoController = TextEditingController();
  final _clientePrincipalController = TextEditingController();
  final _localTerminalController = TextEditingController();
  final _bookingController = TextEditingController();
  final _navioController = TextEditingController();
  final _idEquipamentoontroller = TextEditingController();
  final _numeroCertificadoController = TextEditingController();
  final _descricaoEmbalagemController = TextEditingController();
  final _planoDeAmostraController = TextEditingController();
  final _idVolumesController = TextEditingController();
  final _empresaController = TextEditingController();
  final _lacreDasAmostrasController = TextEditingController();

  final _numeroContainerController = TextEditingController();
  final _taraController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 3);
  final _capacidadeController = TextEditingController();
  final _razaoRejeicaoController = TextEditingController();
  final _temperaturaController = TextEditingController();
  final _sgs7MetrosController = TextEditingController();
  final _agenciaController = TextEditingController();
  final _loteController = TextEditingController();
  final _provisorioController = TextEditingController();
  final _sgsDefinitivoController = TextEditingController();
  final _outrosController = TextEditingController();
  final _resumoController = TextEditingController();
  final _dataVerificacao = TextEditingController();
  final _dataFabricacao = TextEditingController();
  final _dataLote = TextEditingController();

  int _doubleCheck = 2;
  int _condicao = 1;

  bool existeDuplicidade = false;
  DateTime initialDate;
  DateTime selectedDate;

  AlwaysDisabledFocusNode _focusNodeDataVerificacao;

  @override
  void initState() {
    blocContainer.carregarNumeroContainer(uuid: blocSugar.valueUUIDFormAtual);
    _focusNodeDataVerificacao = AlwaysDisabledFocusNode();
    carregarCampos();
    initialDate = DateTime.now();
    selectedDate = initialDate;
    super.initState();
  }

  @override
  void dispose() {
    blocSugar.getFormulario();
    super.dispose();
  }

  double maxValue(double value, double max) {
    if (value < max) {
      return value;
    } else {
      return max;
    }
  }

  bool _chkInspecao = false;
  bool _chkEstufagem = false;
  bool _chkDesova = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(3),
          child: Column(
            children: <Widget>[
              Form(
                key: blocContainer.keyFormInspEstufDesova,
                child: StreamBuilder<bool>(
                    initialData: false,
                    stream: blocContainer.outAutoValidateInspEstuDeso,
                    builder: (context, snapshotForm) {
                      return Column(
                        children: <Widget>[

                          Padding(
                              padding: EdgeInsets.all(10),
                              child: richText(
                                FlutterI18n.translate(context,
                                    "containerInspecaoEstufagemDesova.tipo"),
                              )),

                          Card( //CHECKBOXES de inspeção, estufagem e desova
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0),
                                ),

                                _checkBox.checkBox(
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.checkBoxInspecao"),
                                        (s) {
                                      setState(() {
                                        _chkInspecao = s;
                                      });
                                      blocContainer.sinkInspecao.add(s);
                                      if (snapshotForm.data) {
                                        blocContainer
                                            .validateSinkTipoInspEstuDeso();
                                      }
                                    },
                                    stream: blocContainer.outInspecao,
                                    fontSize:
                                    maxValue(size.width * 0.03, 16)),

                                _checkBox.checkBox(
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.checkBoxEstufagem"),
                                        (s) {
                                      setState(() {
                                        _chkEstufagem = s;
                                      });
                                      blocContainer.sinkEstufagem.add(s);
                                      if (snapshotForm.data) {
                                        blocContainer
                                            .validateSinkTipoInspEstuDeso();
                                      }
                                    },
                                    stream: blocContainer.outEstufagem,
                                    fontSize:
                                    maxValue(size.width * 0.03, 16)),
                                _checkBox.checkBox(
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.checkBoxDesova"),
                                        (s) {
                                      setState(() {
                                        _chkDesova = s;
                                      });
                                      blocContainer.sinkDesova.add(s);
                                      if (snapshotForm.data) {
                                        blocContainer
                                            .validateSinkTipoInspEstuDeso();
                                      }
                                    },
                                    stream: blocContainer.outDesova,
                                    fontSize:
                                    maxValue(size.width * 0.03, 16)),

                                StreamBuilder<bool>(
                                    initialData: false,
                                    stream:
                                    blocContainer.outValidateTipoInspEstuDeso,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == false) {
                                        return SizedBox();
                                      } else {
                                        return SizedBox();
                                          Text(
                                          FlutterI18n.translate(context,
                                              "containerInspecaoEstufagemDesova.msgSelecionarTipo"),
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        );
                                      }
                                    }),

                                Divider(
                                  indent: 15.0,
                                  endIndent: 15.0,
                                  color: Color.fromARGB(255, 243, 112, 33),
                                ),
                              ],
                            ),
                          ),

                          _chkInspecao || _chkEstufagem || _chkDesova ? (
                          Card(
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0),
                                 ),

                                _tff.textFormField(
                                  _bookingController,
                                  FlutterI18n.translate(context,
                                      "containerInspecaoEstufagemDesova.booking"),
                                  FlutterI18n.translate(context,
                                      "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                  false,
                                  verificarValidate: true,
                                  autoValidate: snapshotForm.data,
                                  campoObrigatorio: true,
                                  maxLength: 20,
                                  maxLines: null,
                                  stream: blocContainer.outBooking,
                                  onChanged: blocContainer.changeBooking,
                                  typeText: TextInputType.text,
                                ),

                                _tff.textFormField(
                                    _matriculaController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.matriculaInspetor"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: true,
                                    maxLength: 10,
                                    maxLines: null,
                                    autoValidate: snapshotForm.data,
                                    verificarValidate: true,
                                    stream: blocContainer.outMatricula,
                                    onChanged: blocContainer.changeMatricula),

                                _tff.textFormField(
                                    _ordemServicoController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.ordemServico"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: true,
                                    maxLength: 20,
                                    maxLines: null,
                                    isInputFormatters: true,
                                    typeText: TextInputType.number,
                                    autoValidate: snapshotForm.data,
                                    verificarValidate: true,
                                    stream: blocContainer.outOrdemDeServico,
                                    onChanged:
                                    blocContainer.changeOrdemDeServico),
                                _tff.textFormField(
                                    _clientePrincipalController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.clientePrincipal"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: true,
                                    maxLength: 20,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    autoValidate: snapshotForm.data,
                                    verificarValidate: true,
                                    stream: blocContainer.outClientePrincipal,
                                    onChanged:
                                    blocContainer.changeClientePrincipal),
                                _tff.textFormField(
                                    _localTerminalController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.localTerminal"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: true,
                                    maxLength: 30,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    autoValidate: snapshotForm.data,
                                    verificarValidate: true,
                                    stream: blocContainer.outLocalTerminal,
                                    onChanged: blocContainer.changeLocalTerminal),

                                _chkEstufagem || _chkDesova ? (//Dropdown de produtos
                                Form(
                                  autovalidate: snapshotForm.data,
                                  key:
                                  blocContainer.keyComboProdutoInspEstuDesova,
                                  child: StreamBuilder<List<Produto>>(
                                      stream: blocProduto.outGenericBloc,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                          case ConnectionState.none:
                                            return SizedBox();
                                          case ConnectionState.active:
                                            return DropDownFormField
                                                .dropDownSugar(
                                                dropDown:
                                                DropdownButtonFormField<
                                                    Produto>(
                                                  decoration: DropDownFormField
                                                      .decoratorDropDown(),
                                                  validator: (Produto value) {
                                                    if (value == null && (_chkDesova || _chkEstufagem)) {
                                                      return FlutterI18n.translate(
                                                          context,
                                                          "containerInspecaoEstufagemDesova.msgProdutoObrigatorio");
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  hint: Text(
                                                      FlutterI18n.translate(
                                                          context,
                                                          "containerInspecaoEstufagemDesova.comboProdutos")),
                                                  value: blocProduto
                                                      .valueProdutoInspEstuDesova,
                                                  onChanged: (Produto produto) {
                                                    blocProduto
                                                        .valueProdutoInspEstuDesova =
                                                        produto;
                                                    blocProduto.sinkGenericBloc
                                                        .add(blocProduto.produtos);
                                                    if (snapshotForm.data) {
                                                      blocContainer
                                                          .keyFormInspEstufDesova
                                                          .currentState
                                                          .validate();
                                                    }
                                                  },
                                                  items: snapshot.data
                                                      .map((Produto produto) {
                                                    return DropdownMenuItem<Produto>(
                                                      value: produto,
                                                      child: Text(
                                                        produto.nomeProduto,
                                                        style:
                                                        TextStyle(fontSize: 10),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ));
                                          default:
                                            return Row(
                                              children: <Widget>[
                                                Text(FlutterI18n.translate(
                                                    context,
                                                    "msgValidacoesTelaInspecaoEstufagemDesova.msgErroBuscarComboProduto")),
                                                Text("${snapshot.error}"),
                                              ],
                                            );
                                        }
                                      }),
                                )
                                )
                                : SizedBox(),


                                _tff.textFormField(
                                    _navioController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.navio"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: false,
                                    maxLength: 30,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outNavio,
                                    onChanged: blocContainer.changeNavio),

                                _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _idEquipamentoontroller,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.identificacaoEquipamento"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 150,
                                    maxLines: null,
                                    typeText: TextInputType.multiline,
                                    stream:
                                    blocContainer.outIdentificacaoEquipamento,
                                    onChanged: blocContainer
                                        .changeIdentificacaoDoEquipamento))
                                : SizedBox(),

                                 _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _numeroCertificadoController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.numeroCertificado"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 15,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outNumeroCertificado,
                                    onChanged:
                                    blocContainer.changeNumeroDoCertificado))
                                 : SizedBox(),

                                  _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _dataVerificacao,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.dataVerificacao"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: true,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    stream: blocContainer.outDataVerificacao,
                                    typeText: TextInputType.text,
                                    onChanged:
                                    blocContainer.changeDataDeVerificacao,
                                    disableFocusNode: _focusNodeDataVerificacao,
                                    onTap: () async {
                                      MesAno date = MesAno();
                                      DateTime dateMesAno;
                                      dateMesAno = await date.mesAno(context, selectedDate, initialDate);
                                      if(dateMesAno != null){
                                        _dataVerificacao.text = DateFormat('MM/yy').format(dateMesAno);
                                        blocContainer.sinkDataDeVerificacao.add(dateMesAno);
                                      }
                                      _focusNodeDataVerificacao.unfocus();
                                    }
                                ))
                                  : SizedBox(),

                                  _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _descricaoEmbalagemController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.descricaoEmbalagem"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 300,
                                    maxLines: null,
                                    typeText: TextInputType.multiline,
                                    stream: blocContainer.outDescricaoEmbalagem,
                                    onChanged:
                                    blocContainer.changeDescricaoEmbalagem))
                                  : SizedBox(),

                                  _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _planoDeAmostraController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.planoAmostragem"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 15,
                                    maxLines: null,
                                    stream: blocContainer.outPlanosAmostragem,
                                    onChanged:
                                    blocContainer.changePlanoDeAmostragem))
                                  : SizedBox(),

                                  _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _idVolumesController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.identificacaoVolumes"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    campoObrigatorio: false,
                                    maxLength: 50,
                                    maxLines: null,
                                    stream:
                                    blocContainer.outIdentificacaoDosVolumes,
                                    onChanged: blocContainer
                                        .changeIdentificacaoDosVolumes))
                                  : SizedBox(),

                                  _chkEstufagem || _chkDesova ? (
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: "Double Check ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red)),
                                            ]),
                                          ),
                                        ),
                                        StreamBuilder<int>(
                                          stream: blocContainer.outDoubleCheck,
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.22),
                                              child: Row(
                                                children: <Widget>[
                                                  Radio(
                                                      activeColor: Color.fromARGB(
                                                          255, 243, 112, 33),
                                                      value: 1,
                                                      groupValue: _doubleCheck,
                                                      onChanged: (selc) {
                                                        _empresaController.clear();
                                                        _lacreDasAmostrasController.clear();
                                                        print(selc);
                                                        _doubleCheck = selc;
                                                        blocContainer
                                                            .sinkDoubleCheck
                                                            .add(_doubleCheck);
                                                      }),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 50),
                                                    child: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "containerInspecaoEstufagemDesova.doubleCheckSim")),
                                                  ),
                                                  Radio(
                                                      activeColor: Color.fromARGB(
                                                          255, 243, 112, 33),
                                                      value: 2,
                                                      groupValue: _doubleCheck,
                                                      onChanged: (selc) {
                                                        _empresaController.clear();
                                                        _lacreDasAmostrasController.clear();
                                                        print(selc);
                                                        _doubleCheck = selc;
                                                        blocContainer
                                                            .sinkDoubleCheck
                                                            .add(_doubleCheck);
                                                      }),
                                                  Text(FlutterI18n.translate(
                                                      context,
                                                      "containerInspecaoEstufagemDesova.doubleCheckNao")),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ))
                                  : SizedBox(),


                                StreamBuilder<int>(
                                  stream: blocContainer.outDoubleCheck,
                                  builder: (context, snapshot) {
                                    return snapshot.data == 1
                                        ? Column(
                                      children: <Widget>[
                                        _chkEstufagem || _chkDesova ? (
                                        _tff.textFormField(
                                            _empresaController,
                                            FlutterI18n.translate(context,
                                                "containerInspecaoEstufagemDesova.empresa"),
                                            FlutterI18n.translate(context,
                                                "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                            false,
                                            verificarValidate: false,
                                            autoValidate: snapshotForm.data,
                                            campoObrigatorio: true,
                                            maxLength: 20,
                                            maxLines: null,
                                            typeText: TextInputType.text,
                                            stream:
                                            blocContainer.outEmpresa,
                                            onChanged: blocContainer
                                                .changeEmpresa))
                                        : SizedBox(),

                                        _chkEstufagem || _chkDesova ? (
                                        _tff.textFormField(
                                            _lacreDasAmostrasController,
                                            FlutterI18n.translate(context,
                                                "containerInspecaoEstufagemDesova.lacreAmostras"),
                                            FlutterI18n.translate(context,
                                                "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                            false,
                                            campoObrigatorio: false,
                                            maxLength: 10,
                                            isInputFormatters: true,
                                            maxLines: null,
                                            typeText: TextInputType.number,
                                            stream: blocContainer
                                                .outLacreDasAmostras,
                                            onChanged: blocContainer
                                                .changeLacreDasAmostras))
                                            : SizedBox(),
                                      ],
                                    )
                                        : SizedBox();
                                  },
                                ),
                              ],
                            ),
                          ))
                              : SizedBox(),
                        ],
                      );
                    }),
              ),
              _chkInspecao || _chkEstufagem || _chkDesova ? (
              Column(
                children: <Widget>[
                  Form(
                    key: blocContainer.keyFormInspEstufInformacaoCon,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                      child: StreamBuilder<bool>(
                          initialData: false,
                          stream: blocContainer
                              .outAutoValidateInspEstuDesoInfoContainer,
                          builder: (context, snapshotForm) {
                            return Column(
                              children: <Widget>[
                                _chkInspecao ? (
                                _tff.textFormField(
                                    _numeroContainerController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.numeroContainer"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 20,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outNumeroDoContainer,
                                    onChanged:
                                    blocContainer.changeNumeroDoContainer))
                                : SizedBox(),

                                _chkInspecao ? (
                                _tff.textFormField(
                                    _taraController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.tara"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 10,
                                    maxLines: null,
                                    typeText: TextInputType.number,
                                    stream: blocContainer.outTara,
                                    onChanged: (v) {
                                      blocContainer.sinkTara.add(
                                          _taraController.numberValue.toString());
                                    }))
                                : SizedBox(),

                                _chkInspecao ? (
                                _tff.textFormField(
                                    _capacidadeController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.capacidade"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 10,
                                    isInputFormatters: true,
                                    maxLines: null,
                                    typeText: TextInputType.number,
                                    stream: blocContainer.outCapacidade,
                                    onChanged: blocContainer.changeCapacidade))
                                : SizedBox(),

                                _chkInspecao ? (
                                BotaoData(
                                  FlutterI18n.translate(context,
                                      "containerInspecaoEstufagemDesova.dataFabricacao"),
                                  controller: _dataFabricacao,
                                  campoObrigatorio: true,
                                  stream: blocContainer.outDataFabricacao,
                                  autoValidate: snapshotForm.data,
                                  onChanged: blocContainer.changeDataDeFabricacao,
                                  msgErroValidate: FlutterI18n.translate(context,
                                      "containerInspecaoEstufagemDesova.msgDataFabricacao"),
                                ))
                                : SizedBox(),


                                _chkInspecao ? (
                                Column(
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: FlutterI18n.translate(context,
                                              "containerInspecaoEstufagemDesova.condicao"),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black)),
                                        TextSpan(
                                            text: "*",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red)),
                                          ]),
                                        ),

//                                richText(
//                                    FlutterI18n.translate(context,
//                                        "containerInspecaoEstufagemDesova.condicao"),
//                                    CdQPdS: true),

                                StreamBuilder<int>(
                                  stream: blocContainer.outCondicao,
                                  builder: (context, snapshot) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                          MediaQuery.of(context).size.width *
                                              0.22),
                                      child: Row(
                                        children: <Widget>[
                                          Radio(
                                              activeColor: Color.fromARGB(
                                                  255, 243, 112, 33),
                                              value: 1,
                                              groupValue: _condicao,
                                              onChanged: (selc) {
                                                _razaoRejeicaoController.clear();
                                                _condicao = selc;
                                                blocContainer.sinkCondicao
                                                    .add(_condicao);
                                              }),
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(FlutterI18n.translate(
                                                context,
                                                "containerInspecaoEstufagemDesova.condicaoAprovado")),
                                          ),
                                          Radio(
                                              activeColor: Color.fromARGB(
                                                  255, 243, 112, 33),
                                              value: 2,
                                              groupValue: _condicao,
                                              onChanged: (selc) {
                                                _razaoRejeicaoController.clear();
                                                _condicao = selc;
                                                blocContainer.sinkCondicao
                                                    .add(_condicao);
                                              }),
                                          Text(FlutterI18n.translate(context,
                                              "containerInspecaoEstufagemDesova.condicaoReprovado")),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                StreamBuilder<int>(
                                  stream: blocContainer.outCondicao,
                                  builder: (context, snapshot) {
                                    return snapshot.data == 2
                                        ? _tff.textFormField(
                                        _razaoRejeicaoController,
                                        FlutterI18n.translate(context,
                                            "containerInspecaoEstufagemDesova.razaoRejeicao"),
                                        FlutterI18n.translate(context,
                                            "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                        false,
                                        verificarValidate: true,
                                        autoValidate: snapshotForm.data,
                                        campoObrigatorio: true,
                                        maxLength: 100,
                                        maxLines: null,
                                        typeText: TextInputType.multiline,
                                        stream:
                                        blocContainer.outRazaoRejeicao,
                                        onChanged: blocContainer
                                            .changeRazaoDaRejeicao)
                                        : SizedBox();
                                  },
                                ),
                                ]))
                                : SizedBox(),

                                _chkEstufagem || _chkDesova ? (
                                _tff.textFormField(
                                    _temperaturaController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.temperatura"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: false,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 10,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outTemperatura,
                                    onChanged: blocContainer.changeTemperatura))
                                : SizedBox(),

                                Center(
                                  child: Text(
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.lacres"),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),

                                _chkEstufagem || _chkDesova ?(
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: _tff.textFormField(
                                                _sgs7MetrosController,
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.sgs7Metros"),
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                                false,
                                                campoObrigatorio: false,
                                                maxLength: 10,
                                                maxLines: null,
                                                isInputFormatters: true,
                                                typeText: TextInputType.number,
                                                stream: blocContainer
                                                    .outLacreSgs7Metros,
                                                onChanged: blocContainer
                                                    .changeSGS7Metros),
                                          ),
                                          Expanded(
                                            child: _tff.textFormField(
                                                _sgsDefinitivoController,
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.sgsDefinitivo"),
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                                false,
                                                campoObrigatorio: false,
                                                maxLength: 10,
                                                maxLines: null,
                                                typeText: TextInputType.number,
                                                isInputFormatters: true,
                                                stream: blocContainer
                                                    .outLacreDefinitivo,
                                                onChanged: blocContainer
                                                    .changeSGSDefinitivo),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: _tff.textFormField(
                                                _agenciaController,
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.agencia"),
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                                false,
                                                campoObrigatorio: false,
                                                maxLength: 10,
                                                maxLines: null,
                                                typeText: TextInputType.text,
                                                stream:
                                                blocContainer.outLacreAgencia,
                                                onChanged:
                                                blocContainer.changeAgencia),
                                          ),
                                          Expanded(
                                            child: _tff.textFormField(
                                                _outrosController,
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.outros"),
                                                FlutterI18n.translate(context,
                                                    "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                                false,
                                                campoObrigatorio: false,
                                                maxLength: 10,
                                                maxLines: null,
                                                isInputFormatters: true,
                                                typeText: TextInputType.number,
                                                stream:
                                                blocContainer.outLacreOutros,
                                                onChanged:
                                                blocContainer.changeOutros),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                                : SizedBox(),
                                _tff.textFormField(
                                    _loteController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.lote"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: true,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 15,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outLote,
                                    onChanged: blocContainer.changeLote),

                                _tff.textFormField(
                                    _provisorioController,
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.provisorio"),
                                    FlutterI18n.translate(context,
                                        "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                    false,
                                    verificarValidate: true,
                                    autoValidate: snapshotForm.data,
                                    campoObrigatorio: true,
                                    maxLength: 15,
                                    maxLines: null,
                                    typeText: TextInputType.text,
                                    stream: blocContainer.outProvisorio,
                                    onChanged: blocContainer.changeProvisorio),

                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: blocContainer.keyFormControleQtd,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          gridView(),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: StreamBuilder<List<String>>(
                              stream: blocContainer.outListControleDeQuant,
                              builder: (context, snapshot) {
                                return Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "containerInspecaoEstufagemDesova.totalControleQuantidade")),
                                        Text(
                                            "${blocContainer
                                                .totalControleQuant()}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "containerInspecaoEstufagemDesova.unidades")),
                                        Text(
                                            "${blocContainer
                                                .unidadesControleQuant()}"),
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
                            stream: blocContainer.outValidateControleDeQuantidade,
                            initialData: false,
                            builder: (context, snapshot) {
                              if (snapshot.data == false) {
                                return SizedBox();
                              } else {
                                return Text(
                                  FlutterI18n.translate(context,
                                      "containerInspecaoEstufagemDesova.msgControleQuantidade"),
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
                                onPressed: () async {
                                  bool isInvalid = await showDialog(
                                      context: context,
                                      builder: (context) => AddValor());

                                  isInvalid == true
                                      ? Scaffold.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      FlutterI18n.translate(context,
                                          "msgValidacoesTelaInspecaoEstufagemDesova.msgErroInserirValorSemPontoFlutuante"),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ))
                                      : Container();

                                  blocContainer.sinkValidateControleDeQuantidade
                                      .add(false);
                                },
                                color: Color.fromARGB(255, 243, 112, 33),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<List<InformacaoContainer>>(// TODO #01- Resumo exibido somente ao finalizar
                    stream: blocContainer.outListInicialInspecaoEstufagemDesova,
                    builder: (context, snapshot) {
                      int valor;
                      snapshot.data == null
                          ? valor = 0
                          : valor = snapshot.data.length;
                      return (valor <= 0)
                          ? SizedBox(
                        height: 10,
                      )
                          : Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: clv.containerListView(
                            context: context,
                            tituloContainer: FlutterI18n.translate(context,
                                "containerInspecaoEstufagemDesova.listaTelaInspecaoEstufagemDesovaTitulo"),
                            child: StreamBuilder<List<InformacaoContainer>>(
                              stream: blocContainer
                                  .outListInicialInspecaoEstufagemDesova,
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
                                      return lcied
                                          .lisContainerInspecaoEstufagemDesova(
                                          contextPageInspEstuDeso:
                                          context,
                                          listInformacaoContainer:
                                          snapshot.data);
                                    }
                                    break;
                                  default:
                                    return Row(
                                      children: <Widget>[
                                        Text(FlutterI18n.translate(context,
                                            "msgValidacoesTelaInspecaoEstufagemDesova.msgErroBuscarInspecaoEstufagemDesova")),
                                        Text("${snapshot.error}")
                                      ],
                                    );
                                }
                              },
                            ),
                          ));
                    },
                  ),

                  Form(
                    key: blocContainer.keyFormInspEstufDesovaResumo,
                    child: StreamBuilder<bool>(
                        initialData: false,
                        stream: blocContainer.outAutoValidateInspEstuDeso,
                        builder: (context, snapshotForm) {
                          return Card(
                            margin: EdgeInsets.only(top: 10, bottom: 100),
                            elevation: 5,
                            child: _tff.textFormField(
                                _resumoController,
                                FlutterI18n.translate(context,
                                    "containerInspecaoEstufagemDesova.resumo"),
                                FlutterI18n.translate(context,
                                    "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                                false,
                                verificarValidate: true,
                                autoValidate: snapshotForm.data,
                                campoObrigatorio: true,
                                maxLength: 250,
                                maxLines: null,
                                typeText: TextInputType.multiline,
                                stream: blocContainer.outResumo,
                                onChanged: blocContainer.changeResumo),
                          );
                        }),

                  ),

                ],

              ))
                  : SizedBox(),

            ],

          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnInspEstuDeso',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (validateInspEstufDeso() && !existeDuplicidade) {
              final blocSugar =
              BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

              bool sucesso = await blocContainer
                  .salvarInspecaoEstufagemDesova(blocSugar.valueUUIDFormAtual);

              if (sucesso) {
                //limparInspEstufDesov();
                blocContainer.inAutoValidateInspEstuDesoInfoContainer.add(false);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaInspecaoEstufagemDesova.msgDadosSalvosComSucesso"),
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
                        "msgValidacoesTelaInspecaoEstufagemDesova.msgErroAoSalvar"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
            } else {
              if (existeDuplicidade) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            FlutterI18n.translate(context,
                                "msgValidacoesTelaInspecaoEstufagemDesova.msgErroNumeroContainerExistenteValor1"),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "${_numeroContainerController.text} ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                          FlutterI18n.translate(context,
                              "msgValidacoesTelaInspecaoEstufagemDesova.msgErroNumeroContainerExistenteValor2"),
                          style: TextStyle(fontSize: 16))
                    ],
                  ),
                  backgroundColor: Colors.orange,
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaInspecaoEstufagemDesova.msgCamposObrigatorios"),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ));
              }
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

  Widget gridView() {
    final blocContainer =
    BlocProvider.tag('container').getBloc<ContainerBloc>();
    return Column(
      children: <Widget>[
        richText(
            FlutterI18n.translate(
                context, "containerInspecaoEstufagemDesova.controleQuantidade"),
            CdQPdS: true),
        Container(
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: Color.fromARGB(255, 243, 112, 33), width: 1)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                border: Border.all(
                    color: Color.fromARGB(255, 243, 112, 33).withOpacity(0.5),
                    width: 0.1)),
            child: StreamBuilder<List<String>>(
                stream: blocContainer.outListControleDeQuant,
                builder: (context, snapshot) {
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
                              blocContainer.listAuxControleDeQuantidade
                                  .removeAt(index);
                              blocContainer.sinkListControleDeQuant.add(
                                  blocContainer
                                      .listAuxControleDeQuantidade);

                              bool validateControleQuant = blocContainer
                                  .validateControleDeQuantidade();
                              if (validateControleQuant) {
                                blocContainer
                                    .sinkValidateControleDeQuantidade
                                    .add(true);
                              } else {
                                blocContainer
                                    .sinkValidateControleDeQuantidade
                                    .add(false);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color:
                                      Color.fromARGB(255, 243, 112, 33),
                                      width: 1)),
                              alignment: Alignment.center,
                              child: Text(snapshot.data[index]),
                            ));
                      })
                      : Container();
                }),
          ),
        )
      ],
    );
  }

  bool validateInspEstufDeso() {
    blocContainer.inAutoValidateInspEstuDeso.add(true);
    blocContainer.inAutoValidateInspEstuDesoInfoContainer.add(true);
    blocContainer.inAutoValidateInspEstuDesoResumoQtd.add(true);


    bool tipo = blocContainer.validateTipoInspDeso();

    /// Confere se algum tipo foi selecionado
    blocContainer.validateSinkTipoInspEstuDeso();

    /// Redundância??

    //if (_chkEstufagem || _chkDesova) {///===ABRE VALID===
      bool controleQuant = blocContainer.validateControleDeQuantidade();

      /// ==ED== Existe controle de quantidade. Retorna false caso correto
      if (controleQuant) {
        blocContainer.sinkValidateControleDeQuantidade.add(true);
      }

      int contContainer = 0;
      blocNumeroDoContainer.valueListNumeroDosContainers
          .forEach((valueContainer) {
        /// ==ED== Valida contagem de containers. Retorna int > 1 caso correto
        if (_numeroContainerController.text == valueContainer) {
          existeDuplicidade = true;
        } else {
          contContainer++;
        }
      });

      if (contContainer ==
          blocNumeroDoContainer.valueListNumeroDosContainers.length) {
        /// ==ED== Valida duplicidade de containers. Retorna false caso correto
        existeDuplicidade = false;
      }


      /// Retorna true caso correto
      if (blocContainer.keyFormInspEstufInformacaoCon.currentState.validate() &&
          blocContainer.keyFormControleQtd.currentState.validate() &&
          !tipo &&
          !controleQuant &&
          blocContainer.keyFormInspEstufDesovaResumo.currentState.validate() &&
          blocContainer.keyFormInspEstufDesova.currentState.validate() &&
          blocContainer.keyComboProdutoInspEstuDesova.currentState.validate()) {
        return true;
      } else {
        return false;
      }
     /// ===FECHA VALID===
  }

  bool validateInspEstuDesoResumido() {
    bool tipo = blocContainer.validateTipoInspDeso();
    blocContainer.validateSinkTipoInspEstuDeso();

    if (blocContainer.listInspEstuDesoInfo != null &&
        blocContainer.listInspEstuDesoInfo.isNotEmpty &&
        blocContainer.listInspEstuDesoInfo.length > 0) {
      if (blocContainer.keyFormInspEstufDesova.currentState.validate() &&
          blocContainer.keyFormInspEstufDesovaResumo.currentState.validate() &&
          !tipo) {
        return true;
      } else {
        return false;
      }
    } else {
      blocContainer.inAutoValidateInspEstuDeso.add(true);
      blocContainer.inAutoValidateInspEstuDesoInfoContainer.add(true);
      blocContainer.inAutoValidateInspEstuDesoResumoQtd.add(true);

      blocContainer.validateSinkTipoInspEstuDeso();

      bool controleQuant = blocContainer.validateControleDeQuantidade();
      if (controleQuant) {
        blocContainer.sinkValidateControleDeQuantidade.add(true);
      }
      return false;
    }
  }

  //TODO Incluir novos campos do formulario aqui

  carregarCampos() async {
    DadosContainer dados;
    dados = await blocSugar.getDadosContainer();
    if (dados != null) {
      if (dados.inspecao == true) {
        blocContainer.sinkInspecao.add(true);
      }
      if (dados.estufagem == true) {
        blocContainer.sinkEstufagem.add(true);
      }
      if (dados.desova == true) {
        blocContainer.sinkDesova.add(true);
      }

      if (dados.matricula != null) {
        _matriculaController.text = dados.matricula;
        blocContainer.sinkMatricula.add(dados.matricula);
      }

      if (dados.ordemServico != null) {
        _ordemServicoController.text = dados.ordemServico;
        blocContainer.sinkOrdemDeServico.add(dados.ordemServico);
      }

      if (dados.clientePrincipal != null) {
        _clientePrincipalController.text = dados.clientePrincipal;
        blocContainer.sinkClientePrincipal.add(dados.clientePrincipal);
      }

      if (dados.localTerminal != null) {
        _localTerminalController.text = dados.localTerminal;
        blocContainer.sinkLocalTerminal.add(dados.localTerminal);
      }

      if (dados.produto != null) {
        blocProduto.valueProdutoInspEstuDesova = dados.produto;
        blocProduto.sinkGenericBloc.add(blocProduto.produtos);
        blocContainer.keyComboProdutoInspEstuDesova.currentState.validate();
      }

      if (dados.booking != null) {
        _bookingController.text = dados.booking;
        blocContainer.sinkBooking.add(dados.booking);
      }

      if (dados.navio != null) {
        _navioController.text = dados.navio;
        blocContainer.sinkNavio.add(dados.navio);
      }

      if (dados.identificacaoEquipamento != null) {
        _idEquipamentoontroller.text = dados.identificacaoEquipamento;
        blocContainer.sinkIdentificacaoDoEquipamento
            .add(dados.identificacaoEquipamento);
      }

      if (dados.numeroCertificado != null) {
        _numeroCertificadoController.text = dados.numeroCertificado;
        blocContainer.sinkNumeroDoCertificado.add(dados.numeroCertificado);
      }

      if (dados.dataVerificacao != null) {
        _dataVerificacao.text = dados.dataVerificacao;
        List<String> mesAno = dados.dataVerificacao.split('/');
        blocContainer.sinkDataDeVerificacao
            .add(DateTime.parse('19'+mesAno[1]+'-'+mesAno[0]+'-01'));
      }

      if (dados.descricaoEmbalagem != null) {
        _descricaoEmbalagemController.text = dados.descricaoEmbalagem;
        blocContainer.sinkDescricaoEmbalagem.add(dados.descricaoEmbalagem);
      }

      if (dados.planoAmostragem != null) {
        _planoDeAmostraController.text = dados.planoAmostragem;
        blocContainer.sinkPlanoDeAmostragem.add(dados.planoAmostragem);
      }

      if (dados.identificacaoDosVolumes != null) {
        _idVolumesController.text = dados.identificacaoDosVolumes;
        blocContainer.sinkIdentificacaoDosVolumes
            .add(dados.identificacaoDosVolumes);
      }

      if (dados.empresa != null || dados.lacreDasAmostras != 0) {
        _doubleCheck = 1;
        blocContainer.sinkDoubleCheck.add(1);
        if (dados.empresa != null) {
          _empresaController.text = dados.empresa;
          blocContainer.sinkEmpresa.add(dados.empresa);
        }

        if (dados.lacreDasAmostras != null) {
          _lacreDasAmostrasController.text = dados.lacreDasAmostras.toString();
          blocContainer.sinkLacreDasAmostras
              .add(dados.lacreDasAmostras.toString());
        }
      }

      if (dados.resumo != null) {
        _resumoController.text = dados.resumo;
        blocContainer.sinkResumo.add(dados.resumo);
      }
    }
  }
/*
  limparInspEstufDesov() {
    _numeroContainerController.text = "";
    _taraController.text = "0.000";
    _capacidadeController.text = "";
    _dataFabricacao.text = "";
    _razaoRejeicaoController.text = "";
    _temperaturaController.text = "";
    _sgs7MetrosController.text = "";
    _sgsDefinitivoController.text = "";
    _agenciaController.text = "";
    _outrosController.text = "";
    _loteController.text = "";
    _dataLote.text = "";

    blocContainer.sinkListControleDeQuant.add([]);
    blocContainer.listAuxControleDeQuantidade.clear();

  }
  */

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
              ? TextStyle(fontSize: 15, color: Colors.black)
              : TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      TextSpan(
          text: " *",
          style: CdQPdS == true
              ? TextStyle(fontSize: 14, color: Colors.red)
              : TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red)),
    ]),
  );
}

class AddValor extends StatefulWidget {
  @override
  _AddValorState createState() => _AddValorState();
}

class _AddValorState extends State<AddValor> {
  MyWidget _tff = MyWidget();
  final _valorController = TextEditingController();
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _tff.textFormField(
                  _valorController,
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaInspecaoEstufagemDesova.msgCampoValor"),
                  FlutterI18n.translate(context,
                      "containerInspecaoEstufagemDesova.msgCampoObrigatorio"),
                  false,
                  campoObrigatorio: true,
                  maxLength: 3,
                  maxLines: null,
                  typeText: TextInputType.number,
                  isInputFormatters: true),
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context,
                      "msgValidacoesTelaInspecaoEstufagemDesova.msgCampoAdicionar"),
                  style: TextStyle(color: Colors.white),
                ),
                color: Color.fromARGB(255, 243, 112, 33),
                onPressed: () {
                  if (_valorController.text.contains(".") ||
                      _valorController.text.contains("-")) {
                    Navigator.of(context).pop(true);
                  } else if (_valorController.text.isNotEmpty) {
                    blocContainer.listAuxControleDeQuantidade
                        .add(_valorController.text);
                    blocContainer.sinkListControleDeQuant
                        .add(blocContainer.listAuxControleDeQuantidade);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
