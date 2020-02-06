import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/models/breakbulk.dart';
import 'package:sugar/src/models/dados_breakbulk.dart';
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/produto.dart';
import 'package:sugar/src/ui/widgets/drop_down_validation.dart';
import 'package:sugar/src/ui/widgets/form_text_field.dart';
import 'package:sugar/src/ui/widgets/botao_data.dart';

class SupEmbReceb extends StatefulWidget {
  @override
  _SupEmbRecebState createState() => _SupEmbRecebState();
}

class _SupEmbRecebState extends State<SupEmbReceb>
    with AutomaticKeepAliveClientMixin {
  MyWidget tff = MyWidget();
  final _formKey = GlobalKey<FormState>();

  final _ordemServicoController = TextEditingController();
  final _clientePrincipalController = TextEditingController();
  final _localTerminal = TextEditingController();
  final _navio = TextEditingController();
  final _origem = TextEditingController();


  final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
  final blocSuperEmbRecBloc =
      BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  Formulario formulario;
  DadosBreakBulk dadosBreakBulk;

  List<BreakBulk> breakBulk = [];
  List<DadosBreakBulk> dadosBreakBulks = [];
  DadosBreakBulk dadoBulk = DadosBreakBulk.padrao();

  @override
  void initState() {
    carregarCampos();
    super.initState();
  }

  @override
  void dispose() {
    blocProduto.valueProdutSuperEmbReceb = null;

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
            key: _formKey,
            child: Form(
              key: blocSuperEmbRecBloc.keyFormSuperEmbRece,
              child: Card(
                elevation: 5,
                child: StreamBuilder<bool>(
                    initialData: false,
                    stream: blocSuperEmbRecBloc.outAutoValidateSuperEmbReceb,
                    builder: (context, snapshotForm) {
                      return Column(
                        children: <Widget>[
                          BotaoDataHora(
                            FlutterI18n.translate(
                                context, "breakbulkSuperEmbReceb.dataReferencia"),//TODO Incluir nos arquivos de tradução / Implementar
                            //controller: _selecionarDataInicioController,
                            campoObrigatorio: true,
                            //stream: blocSugarTP.outSelecionarInicioData,
                            autoValidate: snapshotForm.data,
                            //onChanged: blocSugarTP.changeSelecionarDataInicio,
                            msgErro: FlutterI18n.translate(
                                context, "timeLogs.msgDataInicioObrigatorio"),
                          ),
                          Form(
                            autovalidate: snapshotForm.data,
                            key: blocSuperEmbRecBloc.keyComboProdutoSuperEmbRec,
                            child: StreamBuilder<List<Produto>>(
                                stream: blocProduto.outGenericBloc,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.none:
                                      return SizedBox();
                                    case ConnectionState.active:
                                      return DropDownFormField.dropDownSugar(
                                          dropDown:
                                      DropdownButtonFormField<Produto>(
                                        decoration:
                                            DropDownFormField.decoratorDropDown(),
                                        validator: (Produto value) {
                                          if (value == null) {
                                            return FlutterI18n.translate(context,
                                                "breakbulkSuperEmbReceb.msgProdutoObrigatorio");
                                          } else {
                                            return null;
                                          }
                                        },
                                            hint: Text(
                                                FlutterI18n.translate(context,
                                                    "breakbulkSuperEmbReceb.comboProdutos")),
                                        value:
                                        blocProduto.valueProdutSuperEmbReceb,
                                        onChanged: (Produto produto) {
                                          blocProduto.valueProdutSuperEmbReceb =
                                              produto;
                                          blocProduto.sinkGenericBloc
                                              .add(blocProduto.produtos);
                                          if (snapshotForm.data) {
                                            blocSuperEmbRecBloc
                                                .keyFormSuperEmbRece.currentState
                                                .validate();
                                         }
                                        },
                                        items: snapshot.data
                                            .map((Produto produto) {
                                          return DropdownMenuItem<Produto>(

                                            value: produto,
                                            child: Text(
                                              produto.nomeProduto,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                      );
                                    default:
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                              FlutterI18n.translate(context,
                                                  "msgValidacoesTelaSuperEmbReceb.msgErroBuscarComboProduto")),
                                          Text("${snapshot.error}")
                                        ],
                                      );
                                  }
                                }),
                          ),

                          tff.textFormField(
                              _ordemServicoController,
                              FlutterI18n.translate(
                                  context, "breakbulkSuperEmbReceb.ordemServico"),
                              FlutterI18n.translate(context,
                                  "breakbulkSuperEmbReceb.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: true,
                              maxLength: 20,
                              isInputFormatters: true,
                              typeText: TextInputType.number,
                              stream: blocSuperEmbRecBloc.outOrdemServico,
                              onChanged: blocSuperEmbRecBloc.changeOS,
                              verificarValidate: true),
//                          tff.textFormField(_clientePrincipalController,
//                              FlutterI18n.translate(
//                                  context,
//                                  "breakbulkSuperEmbReceb.clientePrincipal"),
//                              FlutterI18n.translate(context,
//                                  "breakbulkSuperEmbReceb.msgCampoObrigatorio"),
//                              false,
//                              autoValidate: snapshotForm.data,
//                              campoObrigatorio: true,
//                              typeText: TextInputType.text,
//                              maxLength: 20,
//                              stream: blocSuperEmbRecBloc.outClientePrincipal,
//                              onChanged:
//                                  blocSuperEmbRecBloc.changeClientePrincipal,
//                              verificarValidate: true),
                          tff.textFormField(
                            _origem,
                            FlutterI18n.translate(
                                context, "breakbulkSuperEmbReceb.usina"),
                            FlutterI18n.translate(context,
                                "breakbulkSuperEmbReceb.msgCampoObrigatorio"),
                            false,
                            campoObrigatorio: true,
                            typeText: TextInputType.text,
                            maxLength: 20,
                            stream: blocSuperEmbRecBloc.outOrigem,
                            onChanged: blocSuperEmbRecBloc.changeOrigem,
                          ),
                          tff.textFormField(_localTerminal, FlutterI18n.translate(
                              context, "breakbulkSuperEmbReceb.localTerminal"),
                              FlutterI18n.translate(context,
                                  "breakbulkSuperEmbReceb.msgCampoObrigatorio"),
                              false,
                              autoValidate: snapshotForm.data,
                              campoObrigatorio: true,
                              typeText: TextInputType.text,
                              maxLength: 30,
                              stream: blocSuperEmbRecBloc.outLocalTerminal,
                              onChanged: blocSuperEmbRecBloc.changeOLocalTerminal,
                              verificarValidate: true),
//                          tff.textFormField(
//                              _navio, FlutterI18n.translate(
//                              context, "breakbulkSuperEmbReceb.navio"),
//                              FlutterI18n.translate(context,
//                                  "breakbulkSuperEmbReceb.msgCampoObrigatorio"),
//                              false,
//                              campoObrigatorio: false,
//                              typeText: TextInputType.text,
//                              stream: blocSuperEmbRecBloc.outNavio,
//                              onChanged: blocSuperEmbRecBloc.changeNavio,
//                              maxLength: 30),

                        ],
                      );
                    }),
              ),
            )),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btnSuperEmbarReceb',
          backgroundColor: Color.fromARGB(255, 243, 112, 33),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            blocSuperEmbRecBloc.inAutoValidateSuperEmbReceb.add(true);
            final blocSugar =
                BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

            if (blocSuperEmbRecBloc.keyFormSuperEmbRece.currentState.validate() &&
                blocSuperEmbRecBloc.keyComboProdutoSuperEmbRec.currentState
                    .validate()) {
              bool sucesso = await blocSuperEmbRecBloc
                  .salvarSuperEmbReceb(blocSugar.valueUUIDFormAtual);
              if (sucesso) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                  Text(
                    FlutterI18n.translate(context,
                        "msgValidacoesTelaSuperEmbReceb.msgDadosSalvosComSucesso"),
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
                        "msgValidacoesTelaSuperEmbReceb.msgErroAoSalvar"),
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
                      "msgValidacoesTelaSuperEmbReceb.msgCamposObrigatorios"),
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

  carregarCampos() async {
    DadosBreakBulk dados;
    dados = await blocSugar.getDadosBreakBulk();

    if (dados != null) {
      if (dados.ordemDeServico != null) {
        _ordemServicoController.text = dados.ordemDeServico.toString();
        blocSuperEmbRecBloc.sinkOrdemServico
            .add(dados.ordemDeServico.toString());
      }
      if (dados.clientePrincipal != null) {
        _clientePrincipalController.text = dados.clientePrincipal;
        blocSuperEmbRecBloc.sinkClientePrincipal.add(dados.clientePrincipal);
      }

      if (dados.localTerminal != null) {
        _localTerminal.text = dados.localTerminal;
        blocSuperEmbRecBloc.sinkLocalTerminal.add(dados.localTerminal);
      }
       if (dados.produto != null) {
        blocProduto.valueProdutSuperEmbReceb = dados.produto;
        blocProduto.sinkGenericBloc.add(blocProduto.produtos);
        blocSuperEmbRecBloc
            .keyFormSuperEmbRece.currentState
            .validate();
      }

      if (dados.navio != null) {
        _navio.text = dados.navio;
        blocSuperEmbRecBloc.sinkNavio.add(dados.navio);
      }

      if (dados.origem != null) {
        _origem.text = dados.origem;
        blocSuperEmbRecBloc.sinkOrigem.add(dados.origem);
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
