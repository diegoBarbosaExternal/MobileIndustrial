import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/ui/pages/assinatura_digital.dart';
import 'package:sugar/src/ui/pages/recebimento.dart';
import 'package:sugar/src/ui/pages/sup_embar_receb.dart';
import 'package:sugar/src/ui/pages/time_logs.dart';
import 'caminhoes_vagoes.dart';
import 'embarque.dart';

class HomeBreakBulk extends StatefulWidget {
  @override
  _HomeBreakBulkState createState() => _HomeBreakBulkState();
}

class _HomeBreakBulkState extends State<HomeBreakBulk> {

  int tabCount = 5;
  String formTipo = "";
  var Extcontext;
  var Extsnapshot;

  final blocSuperEmbRecBloc =
  BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
  final blocTipoUsina =
  BlocProvider.tag('sugarGlobal').getBloc<TipoUsinaBloc>();
  final blocTipoAcucar =
  BlocProvider.tag('sugarGlobal').getBloc<TipoAcucarBloc>();
  final bloc = BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  void dispose() {
    blocProduto.valueProdutoInspEstuDesova = null;
    blocProduto.valueProdutSuperEmbReceb = null;
    blocUsina.valueQuebraNota = null;
    blocUsina.valueRecebimento = null;
    blocUsina.valueSupervisaoPeso = null;
    blocTipoUsina.valueTipoUsina = null;
    blocTipoAcucar.valueTipoAcucarQuebraDeNota = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: bloc.outTipoOperacaoBreakBulk,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none){
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 243, 112, 33),
                    valueColor: AlwaysStoppedAnimation(Colors.white)));
          } else if (snapshot.connectionState == ConnectionState.active) {

            if (snapshot.data == 2) {
              tabCount = 4;
              blocSugar.sinkIdFormAtualSincronizado.add(2);
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: DefaultTabController(
                  length: tabCount,
                  child: Scaffold(
                    appBar: AppBar(
                        title: Text(
                          'Break Bulk',
                          style: TextStyle(fontSize: 25),
                        ),
                        centerTitle: true,
                        backgroundColor: Color.fromARGB(255, 080, 079, 081),
                        bottom:

                        TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color.fromARGB(255, 243, 112, 33),
                            isScrollable: true,
                            tabs: [
                              // SUPER EMB RECEB
                              Tab(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "breakbulkSuperEmbReceb.tituloTabBar"),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              // CAMINHOES
                              Tab(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          FlutterI18n.translate(context,
                                              "breakbulkCaminhoesVagoes.tituloTabBar"),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ])),
                              // TIMELOGS
//                              Tab(
//                                  child: Text(
//                                    FlutterI18n.translate(
//                                        context, "timeLogs.tituloTabBar"),
//                                    style: TextStyle(fontSize: 12),
//                                  )),
                              Tab(
                                  child: Text(
                                    FlutterI18n.translate(context,
                                        "breakbulkEmbarque.tituloTabBar"),
                                    style: TextStyle(fontSize: 12),
                                  )),

//                              Tab(
//                                  child: Text(
//                                      FlutterI18n.translate(context,
//                                          "breakbulkRecebimento.tituloTabBar"),
//                                      style: TextStyle(fontSize: 12))),
                              Tab(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          FlutterI18n.translate(context,
                                              "assinaturaDigital.tituloTabBar"),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ]))
                            ])),

                    body:  TabBarView(
                      children: [
                        SupEmbReceb(),
                        CaminhoesVagoes(),
                        Embarque(),
                        Assinatura(),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              tabCount = 3;
              blocSugar.sinkIdFormAtualSincronizado.add(1);
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: DefaultTabController(
                  length: tabCount,
                  child: Scaffold(
                    appBar: AppBar(
                        title: Text(
                          'Break Bulk',
                          style: TextStyle(fontSize: 25),
                        ),
                        centerTitle: true,
                        backgroundColor: Color.fromARGB(255, 080, 079, 081),
                        bottom:

                        TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color.fromARGB(255, 243, 112, 33),
                            isScrollable: true,
                            tabs: [
                              // SUPER EMB RECEB
                              Tab(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "breakbulkSuperEmbReceb.tituloTabBar"),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              // CAMINHOES
                              Tab(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          FlutterI18n.translate(context,
                                              "breakbulkCaminhoesVagoes.tituloTabBar"),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ])),
                              // TIMELOGS
//                              Tab(
//                                  child: Text(
//                                    FlutterI18n.translate(
//                                        context, "timeLogs.tituloTabBar"),
//                                    style: TextStyle(fontSize: 12),
//                                  )),

                              Tab(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          FlutterI18n.translate(context,
                                              "assinaturaDigital.tituloTabBar"),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ]))
                            ])),

                    body:  TabBarView(
                      children: [
                        SupEmbReceb(),
                        CaminhoesVagoes(),
                        Assinatura(),
                      ],
                    ),

                  ),
                ),
              );
            }

          } else {
            return Text(
                'Erro ao buscar LatLng: ${snapshot.error}'
            );
          }
        }
    );
  }
}


listaTabs4 (){

  TabBarView(
    children: [
      SupEmbReceb(),
      CaminhoesVagoes(),
      Embarque(),
      Assinatura(),
    ],
  );
}

listaTabs3 (){

  TabBarView(
    children: [
      SupEmbReceb(),
      CaminhoesVagoes(),
      Assinatura(),
    ],
  );


}

