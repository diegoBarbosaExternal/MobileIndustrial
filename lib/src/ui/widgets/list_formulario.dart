import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/break_bulk_bloc.dart';
import 'package:sugar/src/blocs/container_bloc.dart';
import 'package:sugar/src/blocs/numero_container_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_formulario_bloc.dart';
import 'package:sugar/src/models/caminhoes_vagoes.dart';
import 'package:sugar/src/models/embarque.dart';
import 'package:sugar/src/models/formulario.dart';
import 'package:sugar/src/models/inf_container.dart';
import 'package:sugar/src/models/quebra_notas_fiscais.dart';
import 'package:sugar/src/models/recebimento.dart';
import 'package:sugar/src/models/time_logs.dart';
import 'package:sugar/src/ui/pages/home_break_bulk.dart';
import 'package:sugar/src/ui/pages/home_container.dart';
import 'package:intl/intl.dart';

/// Status de volume Maximo permitido por container
final int maxVolume = 540;

class ListNaoSincronizados {
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  final bloc = BlocProvider.tag('tipoFormulario').getBloc<TipoFormularioBloc>();

  @override
  Widget listNaoSincrozinados({
    Formulario formulario,
    BuildContext context,
    int tipoForm,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;

    return ListView.builder(
      itemCount: tipoForm == 1
          ? formulario.breakBulk.length
          : formulario.container.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: tipoForm == 1
              ? Key(formulario.breakBulk[index].nomeFormulario + "$index")
              : Key(formulario.container[index].nomeFormulario + "$index"),
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment(-0.9, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.startToEnd,
          child: Card(
           child: ListTile(
            leading: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.red,
            ),
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            title: GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 5),
                width: size.width,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: tipoForm == 1
                      ? Text(
                          formulario.breakBulk[index].nomeFormulario,
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          formulario.container[index].nomeFormulario,
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              onTap: tipoForm == 1
                  ? () async {
                      await blocSugar.getFormulario();

                      blocSugar.sinkUUIDFormAtual
                          .add(formulario.breakBulk[index].uuid);
                      bloc.sinkTipoOperacaoBreakBulk
                          .add(formulario.breakBulk[index].tipoOperacao);
                      bloc.sinkTipoformulario.add(1);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    tagText: "breakbulk",
                                    blocs: [
                                      Bloc((i) => BreakBulkBloc()),
                                    ],
                                    child: HomeBreakBulk(),
                                  )));
                    }
                  : () async {
                      await blocSugar.getFormulario();
                      blocSugar.sinkUUIDFormAtual
                          .add(formulario.container[index].uuid);
                      bloc.sinkTipoformulario.add(2);
                      blocSugar.sinkIdFormAtualSincronizado.add(3);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    tagText: "container",
                                    blocs: [
                                      Bloc((i) => ContainerBloc()),
                                      Bloc((i) =>
                                          DropDowBlocNumeroDoContainer()),
                                    ],
                                    child: HomeContainer(),
                                  )));
                    },
            ),
          )),
          onDismissed: (direcao) {
            if (tipoForm == 1) {
              blocSugar.lastRemovedBreakBulk = formulario.breakBulk[index];
              blocSugar.lastRemovedPositionBreakBulk = index;
              blocSugar.excluirFormBreakBulk(index);

              final snack = SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "${formulario.breakBulk[blocSugar.lastRemovedPositionBreakBulk].nomeFormulario}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      FlutterI18n.translate(context,
                          "msgValidacoesTelaFormularios.msgRemoverFormulario2"),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                action: SnackBarAction(
                  label: FlutterI18n.translate(context,
                      "msgValidacoesTelaFormularios.msgRemoverFormularioDesfazer"),
                  textColor: Color.fromARGB(255, 243, 112, 33),
                  onPressed: () {
                    blocSugar
                        .salvarFormBreakBulk(blocSugar.lastRemovedBreakBulk);
                  },
                ),
                duration: Duration(seconds: 5),
              );
              Scaffold.of(context).showSnackBar(snack);
            } else {
              blocSugar.lastRemovedContainer = formulario.container[index];
              blocSugar.lastRemovedPositionContainer = index;
              blocSugar.excluirFormContainer(index);

              final snack = SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                          "${formulario.container[blocSugar.lastRemovedPositionContainer].nomeFormulario}"),
                    ),
                    Text(FlutterI18n.translate(context,
                        "msgValidacoesTelaFormularios.msgRemoverFormulario2")),
                  ],
                ),
                action: SnackBarAction(
                  label: FlutterI18n.translate(context,
                      "msgValidacoesTelaFormularios.msgRemoverFormularioDesfazer"),
                  textColor: Color.fromARGB(255, 243, 112, 33),
                  onPressed: () {
                    blocSugar
                        .salvarFormContainer(blocSugar.lastRemovedContainer);
                  },
                ),
                duration: Duration(seconds: 5),
              );
              Scaffold.of(context).showSnackBar(snack);
            }
          },
        );
      },
    );
  }
}

class LisContainerCaminhoesVagoes {
  final blocCaminhoesVagoes =
      BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  Widget lisContainerCaminhoesVagoes(
      {BuildContext context, List<CaminhoesVagoes> listCV}) {
    return ListView.builder(
      itemCount: listCV.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                //padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context,
                          "breakbulkCaminhoesVagoes.caminhoesVagoes"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text(": " + '${listCV[index].caminhoesVagoes}')),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context,
                          "breakbulkCaminhoesVagoes.placa"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text(": " + '${listCV[index].placa}')),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context,
                          "breakbulkCaminhoesVagoes.pesoNota"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text(": " + '${listCV[index].pesoNota}')),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context,
                          "breakbulkCaminhoesVagoes.notaFiscal"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text(": " + '${listCV[index].notaFiscal}')),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context,
                          "breakbulkCaminhoesVagoes.quantidadeSacas"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text(": " + '${listCV[index].quantidade}')),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(context,
                        "breakbulkCaminhoesVagoes.avarias"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.molhadas"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(": " + '${listCV[index].molhada ? "Sim": "Não"}'),
                          ],
                        ),

                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.rasgadas"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(": " + '${listCV[index].rasgada ? "Sim": "Não"}'),
                          ],
                        ),

                      ),

                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.sujas"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(": " + '${listCV[index].suja ? "Sim": "Não"}'),
                          ],
                        ),

                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "breakbulkCaminhoesVagoes.empedradas"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(": " + '${listCV[index].empedrada ? "Sim": "Não"}'),
                          ],
                        ),

                      ),

                    ],
                  ),

                ],
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(FlutterI18n.translate(context, "breakbulkCaminhoesVagoes.faltas"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(": " + '${listCV[index].falta}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(FlutterI18n.translate(context, "breakbulkCaminhoesVagoes.sobras"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(": " + '${listCV[index].sobra}'),
                    ],
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.only(left: 10.0, top:10.0),
                child: Row(
                  children: <Widget>[
                    Text(FlutterI18n.translate(context, "breakbulkCaminhoesVagoes.totalUnidades"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(": " + '${listCV[index].totalUnidades}'),
                  ]
                ),
              ),

              IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 243, 112, 33,),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              FlutterI18n.translate(context,
                                  "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialog"),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogTitulo"),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogSubTitulo"),
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Text(
                                  "${index + 1}",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogValor1"),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  child:
                                      Text("${listCV[index].caminhoesVagoes}")),
                              SizedBox(height: 10),
                              Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogValor2"),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                child: Text("${listCV[index].notaFiscal}"),
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      FlutterI18n.translate(context,
                                          "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogValor3"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    child: Expanded(
                                        child: Text(
                                            "${listCV[index].quantidade}")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialogCancelar"),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 243, 112, 33)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaCaminhoesVagoes.msgExcluirCaminhaoVagaoDialog"),
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 243, 112, 33))),
                              onPressed: () {
                                blocCaminhoesVagoes.excluirCaminhoesVagoes(
                                    indice: index,
                                    uuid: blocSugar.valueUUIDFormAtual);

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  })
            ],
          ),
        );
      },
    );
  }
}

class LisContainerTimeLogs {
  @override
  Widget lisContainerTimeLogs({BuildContext context, List<TimeLogs> listTL}) {
    return ListView.builder(
      itemCount: listTL.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "timeLogs.listaTelaTimeLogsTituloColuna11"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text('${listTL[index].dataInicial.toString().length > 15 ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(listTL[index].dataInicial)).toString() : "***"}')),
//                    Flexible(child: Text('${DateFormat('dd/MM/yyyy HH:mm')
//                        .format(DateTime.parse(listTL[index].dataInicial))}')),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "timeLogs.listaTelaTimeLogsTituloColuna21"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text('${listTL[index].dataTermino.toString().length > 15 ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(listTL[index].dataTermino)).toString() : "***"}')),
//                    Flexible(child: Text('${DateFormat('dd/MM/yyyy HH:mm')
//                          .format(DateTime.parse(listTL[index].dataTermino))}')),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "timeLogs.ocorrenciaDialog"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(child: Text('${listTL[index].ocorrencia  ?? ''}')),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 243, 112, 33,),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text(
                              FlutterI18n.translate(context,
                                  "msgValidacoesTelaTimeLogs.msgExcluirTimeLogsDialog"),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaTimeLogs.msgExcluirTimeLogsDialogTitulo"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      FlutterI18n.translate(
                                          context, "timeLogs.tituloTabBar"),
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " Nº ${index + 1}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  FlutterI18n.translate(context,
                                      "timeLogs.listaTelaTimeLogsTituloColuna11"),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                      child: Text('${listTL[index].dataInicial.toString().length > 15 ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(listTL[index].dataInicial)).toString() : "***"}')
//                                    child: Text("${DateFormat('dd/MM/yyyy HH:mm')
//                                        .format(DateTime.parse(listTL[index].dataInicial))}")
                                ),
                                SizedBox(height: 10),
                                Text(
                                    FlutterI18n.translate(context,
                                        "timeLogs.listaTelaTimeLogsTituloColuna21"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                    child: Text('${listTL[index].dataTermino.toString().length > 15 ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(listTL[index].dataTermino)).toString() : "***"}')
//                                  child: Text("${DateFormat('dd/MM/yyyy HH:mm')
//                                      .format(DateTime.parse(listTL[index].dataTermino))}"),
                                ),
                                SizedBox(height: 10),
                                Text(
                                    FlutterI18n.translate(
                                        context, "timeLogs.ocorrenciaDialog"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Text(
                                      "${listTL[index].ocorrencia ?? ''}"),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaTimeLogs.msgExcluirTimeLogsDialogCancelar"),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 243, 112, 33)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaTimeLogs.msgExcluirTimeLogsDialog"),
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 243, 112, 33))),
                              onPressed: () {
                                final blocTP =
                                    BlocProvider.tag('tipoFormulario')
                                        .getBloc<TipoFormularioBloc>();
                                final blocSugar =
                                    BlocProvider.tag('sugarGlobal')
                                        .getBloc<SugarBloc>();
                                var blocSugarTP;
                                int tipoForm = blocTP.getTipo();

                                tipoForm == 1
                                    ? blocSugarTP =
                                        BlocProvider.tag('breakbulk')
                                            .getBloc<BreakBulkBloc>()
                                    : blocSugarTP =
                                        BlocProvider.tag('container')
                                            .getBloc<ContainerBloc>();

                                tipoForm == 1
                                    ? blocSugarTP.excluirTimeLogs(
                                        indice: index,
                                        uuid: blocSugar.valueUUIDFormAtual)
                                    : blocSugarTP.excluirTimeLogs(
                                        indice: index,
                                        uuid: blocSugar.valueUUIDFormAtual);

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  })
            ],
          ),
        );
      },
    );
  }
}

class LisContainerEmbarque {
  final blocCaminhoesVagoes =
      BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  Widget lisContainerEmbarque(
      {BuildContext context, List<Embarque> listEmbarque}) {

    return ListView.builder(
        itemCount: listEmbarque.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkEmbarque.listaTelaEmbarqueTituloColuna11"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child: Text('${listEmbarque[index].quantidadeTotalPeso.toString()}')),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkEmbarque.listaTelaEmbarqueTituloColuna21"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child: Text('${listEmbarque[index].porto}')),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkEmbarque.listaTelaEmbarqueTituloColuna31"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child: Text('${listEmbarque[index].destino}')),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Color.fromARGB(255, 243, 112, 33,),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialog"),
                                style: TextStyle(color: Colors.black87)),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogTitulo"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10.0,),
                               Row(
                                 children: <Widget>[
                                   Text(
                                       FlutterI18n.translate(context,
                                           "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogSubTitulo"),
                                       style: TextStyle(
                                           fontWeight:
                                           FontWeight.bold)),
                                   Text("${index + 1}",
                                       style: TextStyle(
                                           fontWeight:
                                           FontWeight.bold)),
                                 ],
                               ),
                                SizedBox(height: 10.0,),
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogValor1"),
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text("${listEmbarque[index].quantidadeTotalPeso}"),
                                SizedBox(height: 10.0,),
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogValor2"),
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text("${listEmbarque[index].porto}"),
                                SizedBox(height: 10.0,),
                                Text(FlutterI18n.translate(context,
                                        "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogValor3"),
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold)),
                                Text("${listEmbarque[index].destino}"),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialogCancelar"),
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 243, 112, 33)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaEmbarque.msgExcluirEmbarqueDialog"),
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 243, 112, 33))),
                                onPressed: () {
                                  blocCaminhoesVagoes.excluirEmbarque(
                                      indice: index,
                                      uuid:
                                      blocSugar.valueUUIDFormAtual);

                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    })
              ],
            ),
          );
        },
   );
  }
}

class LisContainerRecebimento {
  final blocCaminhoesVagoes =
      BlocProvider.tag('breakbulk').getBloc<BreakBulkBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  Widget lisContainerRecebimento(
      {BuildContext context, List<Recebimento> listRecebimento}) {
    return ListView.builder(
        itemCount: listRecebimento.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkRecebimento.listaTelaRecebimentoTituloColuna11"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child:
                       Text(listRecebimento[index].tipoUsina == null
                        ? "" : listRecebimento[index]
                          .tipoUsina
                          .nomeTipoUsina,
                      style: TextStyle(fontSize: 14),
                      ),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkRecebimento.listaTelaRecebimentoTituloColuna21"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child:
                       Text(listRecebimento[index].usina == null
                       ? "" : listRecebimento[index].usina.usina,
                        style: TextStyle(fontSize: 14),
                      ),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "breakbulkRecebimento.listaTelaRecebimentoTituloColuna31"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child:
                       Text(listRecebimento[index].analiseProduto == null
                           ? ""
                           : listRecebimento[index].analiseProduto,
                        style: TextStyle(fontSize: 14),
                      ),),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Color.fromARGB(255, 243, 112, 33,),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialog"),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            content: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogTitulo"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogSubTitulo"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Text("${index + 1}",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogValor1"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Container(
                                      child: Expanded(
                                          child: Text(
                                              "${listRecebimento[index].tipoUsina.nomeTipoUsina}")),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogValor2"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Container(
                                      child: Expanded(
                                          child: Text(
                                              "${listRecebimento[index].usina.usina}")),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogValor3"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Text(
                                      "${listRecebimento[index].analiseProduto}"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialogCancelar"),
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 243, 112, 33)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaRecebimento.msgExcluirRecebimentoDialog"),
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 243, 112, 33))),
                                onPressed: () {
                                  blocCaminhoesVagoes
                                      .excluirRecebimento(
                                      indice: index,
                                      uuid: blocSugar
                                          .valueUUIDFormAtual);

                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    })
              ],
            ),
          );
        },
    );
  }
}

class LisContainerInspecaoEstufagemDesova {
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();
  final blocNumeroDoContainer =
      BlocProvider.tag('container').getBloc<DropDowBlocNumeroDoContainer>();

  @override
  Widget lisContainerInspecaoEstufagemDesova(
      {contextPageInspEstuDeso,
      List<InformacaoContainer> listInformacaoContainer}) {
    MediaQueryData mediaQuery = MediaQuery.of(contextPageInspEstuDeso);
    Size size = mediaQuery.size;

    return ListView.builder(
        itemCount: listInformacaoContainer.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              children: <Widget>[

                /// Status de volume
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "containerInspecaoEstufagemDesova.listaTelaInspecaoEstufagemDesovaColuna41"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child:  Text( statusVolume(context, listInformacaoContainer[index].total),
                          //listInformacaoContainer[index].numeroContainer,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Numero do Container
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "containerInspecaoEstufagemDesova.listaTelaInspecaoEstufagemDesovaColuna11"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child:  Text(
                          listInformacaoContainer[index].numeroContainer,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Tara
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "containerInspecaoEstufagemDesova.listaTelaInspecaoEstufagemDesovaColuna21"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(listInformacaoContainer[index].tara.toString(),
                          style: TextStyle(fontSize: 14),
                        ),),
                    ],
                  ),
                ),

                /// Capacidade
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "containerInspecaoEstufagemDesova.listaTelaInspecaoEstufagemDesovaColuna31"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(listInformacaoContainer[index].capacidade.toString(),
                          style: TextStyle(fontSize: 14),
                        ),),
                    ],
                  ),
                ),

                /// Total Controle de Quantidade
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "containerInspecaoEstufagemDesova.totalControleQuantidade"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(listInformacaoContainer[index].total.toString() != "null" ? listInformacaoContainer[index].total.toString() : "0",
                          style: TextStyle(fontSize: 14),
                        ),),
                    ],
                  ),
                ),

                IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Color.fromARGB(255, 243, 112, 33,),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialog"),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            content: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogTitulo"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogSubTitulo"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Text("${index + 1}",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogValor1"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Text(
                                      "${listInformacaoContainer[index].numeroContainer}"),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogValor2"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Container(
                                      child: Expanded(
                                          child: Text(
                                              "${listInformacaoContainer[index].tara}")),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(context,
                                            "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogValor3"),
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                    Container(
                                      child: Expanded(
                                          child: Text(
                                              "${listInformacaoContainer[index].capacidade}")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialogCancelar"),
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 243, 112, 33)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                    FlutterI18n.translate(context,
                                        "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesDialog"),
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 243, 112, 33))),
                                onPressed: () async {
                                  if (!blocContainer
                                      .verificarContainerQuebraNota(
                                      listInformacaoContainer[index]
                                          .numeroContainer)) {
                                    await blocContainer
                                        .excluirInspEstufDesova(
                                        indice: index,
                                        uuid: blocSugar
                                            .valueUUIDFormAtual);

                                    await blocContainer
                                        .carregarNumeroContainer(
                                        uuid: blocSugar
                                            .valueUUIDFormAtual);
                                    Navigator.of(context).pop();
                                  } else {
                                    Map<String, String>
                                    numeroContainer =
                                    Map<String, String>();
                                    numeroContainer["numeroContainer"] =
                                        listInformacaoContainer[index]
                                            .numeroContainer;

                                    Navigator.of(context).pop();
                                    Scaffold.of(contextPageInspEstuDeso)
                                    .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 9),
                                      content: Text(
                                        FlutterI18n.translate(
                                            context,
                                            "msgValidacoesTelaInspecaoEstufagemDesova.msgExcluirInpEstufDesValorUsadoQuebraNota1",
                                            numeroContainer),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor: Colors.orange,
                                    ));
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    })
              ],
            ),
          );
        }
    );
  }
}

 String statusVolume(var context, int status){
  String result = "";
  if (status == null || status < 1){
    result = FlutterI18n.translate(context, "containerInspecaoEstufagemDesova.statusVolume1");
  } else if (status > 0 && status < maxVolume){
    result = FlutterI18n.translate(context, "containerInspecaoEstufagemDesova.statusVolume2");
  } else {
    result = FlutterI18n.translate(context, "containerInspecaoEstufagemDesova.statusVolume3");
  }
  return result;
 }

class LisContainerQuebraDeNota {
  final blocContainer = BlocProvider.tag('container').getBloc<ContainerBloc>();
  final blocSugar = BlocProvider.tag('sugarGlobal').getBloc<SugarBloc>();

  @override
  Widget lisContainerQuebraDeNota(
      {BuildContext context, List<QuebraNotasFiscais> listQuebraDeNota}) {
    List<Widget> listTiles = [];

    for (int indexPrincipal = 0;
        indexPrincipal < listQuebraDeNota.length;
        indexPrincipal++) {
      for (int indexQuebraNota = 0;
          indexQuebraNota < listQuebraDeNota[indexPrincipal].quebraNotas.length;
          indexQuebraNota++) {
        listTiles.add(Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "containerQuebraNota.listaTelaQuebraDeNotaDesovaColuna11"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(listQuebraDeNota[indexPrincipal].container,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "containerQuebraNota.listaTelaQuebraDeNotaDesovaColuna21"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(listQuebraDeNota[indexPrincipal]
                        .quebraNotas[indexQuebraNota]
                        .notaFiscal,
                        style: TextStyle(fontSize: 14),
                      ),),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(
                          context, "containerQuebraNota.listaTelaQuebraDeNotaDesovaColuna31"),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(listQuebraDeNota[indexPrincipal]
                        .quebraNotas[indexQuebraNota]
                        .totalPorContainer
                        .toString(),
                        style: TextStyle(fontSize: 14),
                      ),),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 243, 112, 33,),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text(
                              FlutterI18n.translate(context,
                                  "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialog"),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                          content: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogTitulo"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text(
                                      FlutterI18n.translate(context,
                                          "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogSubTitulo"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("${indexQuebraNota + 1}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogValor1"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Text(
                                    "${listQuebraDeNota[indexPrincipal].container}"),
                              ),
                              SizedBox(height: 10),
                              Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogValor2"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "${listQuebraDeNota[indexPrincipal].quebraNotas[indexQuebraNota].notaFiscal}"),
                              SizedBox(height: 10),
                              Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogValor3"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Text(
                                    "${listQuebraDeNota[indexPrincipal].quebraNotas[indexQuebraNota].totalPorContainer}"),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                FlutterI18n.translate(context,
                                    "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialogCancelar"),
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 243, 112, 33)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                  FlutterI18n.translate(context,
                                      "msgValidacoesTelaQuebraDeNota.msgExcluirQuebraDeNotasDialog"),
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 243, 112, 33))),
                              onPressed: () {
                                blocContainer.excluirQuebraDeNota(
                                    indicePrincipal: indexPrincipal,
                                    indiceQuebraNota: indexQuebraNota,
                                    uuid: blocSugar.valueUUIDFormAtual);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  })
            ],
          ),
        ));
      }
      if(!((indexPrincipal + 1) == listQuebraDeNota.length)){
        listTiles.add(Divider(color: Color.fromARGB(255, 243, 112, 33,)));
      }
    }

    return ListView(
      children: listTiles,
    );
  }
}
