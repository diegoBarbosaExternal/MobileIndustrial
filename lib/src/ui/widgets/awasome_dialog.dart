import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AwasomeDialog{

  awasomeDialog(
      {@required context,
        @required dialogType,
        @required animType,
        @required title,
        @required text,
        @required btnOkColor,
        @required btnOkText}) {
    AwesomeDialog(
        btnOkText: btnOkText,
        context: context,
        dialogType: dialogType,
        animType: animType,
        tittle: title,
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Center(
            child: text,
          ),
        ),
        btnOkColor: btnOkColor,
        btnOkOnPress: () {})
        .show();
  }
}