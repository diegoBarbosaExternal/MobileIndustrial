import 'package:flutter/material.dart';

class ContainerListView {
  Widget containerListView({@required String tituloContainer,
    @required BuildContext context,
    @required Widget child}) {

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
                tituloContainer,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 080, 079, 081),
                border: Border.fromBorderSide(BorderSide(
                    color: Color.fromARGB(255, 243, 112, 33,)
                ))),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(
                      color: Color.fromARGB(255, 243, 112, 33,)
                  ))),
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 300,
              child: child)
        ],
      ),
    );
  }
}
