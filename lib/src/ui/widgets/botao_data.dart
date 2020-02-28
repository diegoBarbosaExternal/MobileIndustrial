import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sugar/src/utils/cores.dart';

class BotaoData extends StatefulWidget {
  final String titulo;
  final bool campoObrigatorio;
  final TextEditingController controller;
  final Stream stream;
  final Function onChanged;
  final String msgErroValidate;
  bool autoValidate;

  BotaoData(this.titulo,
      {this.campoObrigatorio = false,
      this.controller,
      this.stream,
      this.onChanged,
      this.msgErroValidate,
      this.autoValidate});

  @override
  _BotaoDataState createState() => _BotaoDataState();
}

class _BotaoDataState extends State<BotaoData> {
  final format = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        return Column(children: <Widget>[
          Text('${widget.titulo}'),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DateTimeField(
              autovalidate: widget.autoValidate,
              validator: (v) {
                if (v == null) {
                  return widget.msgErroValidate;
                } else {
                  return null;
                }
              },
              format: format,
              controller: widget.controller,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              decoration: InputDecoration(
                suffixIcon: widget.campoObrigatorio == false
                    ? null
                    : Icon(
                        Icons.ac_unit,
                        size: 8,
                        color: Colors.red,
                      ),
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 080, 079, 081), fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ]);
      },
    );
  }
}

class BotaoDataHora extends StatefulWidget {
  final String titulo;
  final bool campoObrigatorio;
  final TextEditingController controller;
  final Stream stream;
  final Function onChanged;
  final String msgErro;
  bool autoValidate;

  BotaoDataHora(this.titulo,
      {this.campoObrigatorio = false,
      this.controller,
      this.stream,
      this.onChanged,
      this.autoValidate,
      this.msgErro});

  @override
  _BotaoDataHoraState createState() => _BotaoDataHoraState();
}

class _BotaoDataHoraState extends State<BotaoDataHora> {
  final format = DateFormat("dd/MM/yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        return Column(children: <Widget>[
          Text('${widget.titulo}'),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DateTimeField(
              validator: (dateTime) {
                if (dateTime == null) {
                  return widget.msgErro;
                } else {
                  return null;
                }
              },
              autovalidate: widget.autoValidate,
              format: format,
              controller: widget.controller,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              decoration: InputDecoration(
                suffixIcon: widget.campoObrigatorio == false
                    ? null
                    : Icon(
                        Icons.ac_unit,
                        size: 8,
                        color: Colors.red,
                      ),
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 080, 079, 081), fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ]);
      },
    );
  }
}


 class MesAno {
  Future<DateTime> mesAno(@required BuildContext context,
      @required selectedDate, @required initialDate) async {

    DateTime date;
    await Future.delayed(Duration(seconds: 1)).then((_) async {
      date = await showMonthPicker(
          context: context,
          firstDate: DateTime(DateTime.now().year - 40),
          lastDate: DateTime(DateTime.now().year + 80),
          initialDate: selectedDate ?? initialDate);
    });
    return date;
  }
}
