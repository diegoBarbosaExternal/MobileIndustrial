import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/ui/pages/assinatura_digital.dart';
import 'package:sugar/src/ui/pages/quebra_de_nota.dart';
import 'package:sugar/src/ui/pages/supervisao_de_peso.dart';
import 'package:sugar/src/ui/pages/time_logs.dart';
import 'insp_estuf_desova.dart';

class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocProduto = BlocProvider.tag('sugarGlobal').getBloc<ProdutoBloc>();
  final blocUsina = BlocProvider.tag('sugarGlobal').getBloc<UsinaBloc>();
  final blocTipoUsina =
  BlocProvider.tag('sugarGlobal').getBloc<TipoUsinaBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  void dispose() {
    blocProduto.valueProdutoInspEstuDesova = null;
    blocProduto.valueProdutSuperEmbReceb = null;
    blocUsina.valueQuebraNota = null;
    blocUsina.valueRecebimento = null;
    blocUsina.valueSupervisaoPeso = null;
    blocTipoUsina.valueTipoUsina = null;
    blocSugar.statusTela = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                'Container',
                style: TextStyle(fontSize: 25),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 080, 079, 081),
              bottom: TabBar(
                  onTap: (index){

                  },
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color.fromARGB(255, 243, 112, 33),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Text(
                        FlutterI18n.translate(context,
                            "containerInspecaoEstufagemDesova.tituloTabBar"),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    /*Tab(
                        child: Text(
                          FlutterI18n.translate(context, "timeLogs.tituloTabBar"),
                          style: TextStyle(fontSize: 12),
                        )),*/
                    Tab(
                        child: Text(
                          FlutterI18n.translate(
                              context, "containerSupervisaoDePeso.tituloTabBar"),
                          style: TextStyle(fontSize: 12),
                        )),
                    Tab(
                        child: Text(
                            FlutterI18n.translate(
                                context, "containerQuebraNota.tituloTabBar"),
                            style: TextStyle(fontSize: 12))),
                    Tab(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                FlutterI18n.translate(
                                    context, "assinaturaDigital.tituloTabBar"),
                                style: TextStyle(fontSize: 12),
                              )
                            ]))
                  ])),
          body: TabBarView(children: [
            InspecaoEstufagemDesova(),
            //TimeLogs(),
            SupervisaoDePeso(),
            QuebraDeNota(),
            AssinaturaDigitalPage()
          ]),
        ),
      ),
    );
  }
}
