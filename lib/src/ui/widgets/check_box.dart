import 'package:flutter/material.dart';

class CheckBox{

  Widget checkBox(String texto, Function function,
      {Stream stream, double fontSize }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          texto, style: TextStyle(fontSize: fontSize),
        ),
        StreamBuilder<bool>(
            stream: stream,
            builder: (context, snapshot) {
              return Checkbox(
                value: snapshot.hasData ? snapshot.data : false,
                onChanged: function,
                activeColor: Color.fromARGB(255, 243, 112, 33),
              );
            }),
      ],
    );
  }
}
