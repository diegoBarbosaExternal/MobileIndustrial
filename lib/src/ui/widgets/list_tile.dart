import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/ui/pages/login.dart';

class DrawerListTile {
  Widget drawerListTile(
      BuildContext context, String name, String currentRoute, String route,
      {@required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
          color: currentRoute == route
              ? Color.fromARGB(15, 237, 236, 236)
              : Color.fromARGB(255, 080, 079, 081),
          borderRadius: BorderRadius.circular(30.0)),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        selected: currentRoute == route,
        leading: icon != null
            ? Icon(
                icon,
                color: Color.fromARGB(255, 243, 112, 33),
              )
            : null,
        onTap: () {
          if (route != '' && route != 'sair') {
            Navigator.pushReplacementNamed(context, route);
          }else if(route == 'sair'){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: Text(FlutterI18n.translate(
                      context,
                      "deslogarApp.sair"),
                      style: TextStyle(
                          color: Colors.black87 )),
                  content: Text(FlutterI18n.translate(
                      context,
                      "deslogarApp.deslogarConta")),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(FlutterI18n.translate(
                          context,
                          "deslogarApp.cancelar"),
                        style: TextStyle(
                            color: Color.fromARGB(255, 243, 112, 33) ),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(FlutterI18n.translate(
                          context,
                          "deslogarApp.sair"),
                          style: TextStyle(
                              color: Color.fromARGB(255, 243, 112, 33) )),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
