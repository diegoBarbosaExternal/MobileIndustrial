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
    return DefaultTabController(
        length: 5,
        child: StreamBuilder<int>(
            stream: bloc.outTipoOperacaoBreakBulk,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 243, 112, 33),
                        valueColor: AlwaysStoppedAnimation(Colors.white)));
                case ConnectionState.active:
                  if(snapshot.data == 2){
                    blocSugar.sinkIdFormAtualSincronizado.add(2);
                  }else{
                    blocSugar.sinkIdFormAtualSincronizado.add(1);
                  }
                  return GestureDetector(
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Scaffold(
                      appBar: AppBar(
                          title: Text(
                            'Break Bulk',
                            style: TextStyle(fontSize: 25),
                          ),
                          centerTitle: true,
                          backgroundColor: Color.fromARGB(255, 080, 079, 081),
                          bottom: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color.fromARGB(255, 243, 112, 33),
                              isScrollable: true,
                              tabs: [
                                Tab(
                                  child: Text(
                                    FlutterI18n.translate(context,
                                        "breakbulkSuperEmbReceb.tituloTabBar"),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Tab(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            FlutterI18n.translate(context,
                                                "breakbulkCaminhoesVagoes.tituloTabBar"),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ])),
                                Tab(
                                    child: Text(
                                      FlutterI18n.translate(
                                          context, "timeLogs.tituloTabBar"),
                                      style: TextStyle(fontSize: 12),
                                    )),
                                snapshot.data == 2
                                    ? Tab(
                                    child: Text(
                                      FlutterI18n.translate(context,
                                          "breakbulkEmbarque.tituloTabBar"),
                                      style: TextStyle(fontSize: 12),
                                    ))
                                    : Tab(
                                    child: Text(
                                        FlutterI18n.translate(context,
                                            "breakbulkRecebimento.tituloTabBar"),
                                        style: TextStyle(fontSize: 12))),
                                Tab(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            FlutterI18n.translate(context,
                                                "assinaturaDigital.tituloTabBar"),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ]))
                              ])),
                      body: TabBarView(children: [
                        SupEmbReceb(),
                        CaminhoesVagoes(),
                        TimeLogs(),
                        snapshot.data == 2 ? Embarque() : Recebimento(),
                        AssinaturaDigitalPage(),
                      ]),
                    ),
                  );
                default:
                  return Text(
                      'Error ao buscar LatLng: ${snapshot.error}');
              }


            }));
  }
}
