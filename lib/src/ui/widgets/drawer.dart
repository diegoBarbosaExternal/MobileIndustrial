import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sugar/src/blocs/login_bloc.dart';
import 'package:sugar/src/models/login_model.dart';
import 'package:sugar/src/ui/home/home.dart';

import 'list_tile.dart';

class BuildDrawer {
  DrawerListTile _drawerListTile = DrawerListTile();
  final LoginBloc blocLogin = BlocProvider.tag('sugarGlobal').getBloc<LoginBloc>();

  Drawer buildDrawer(BuildContext context, String currentRoute) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 080, 079, 081),
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            _createHeader(context),
            _drawerListTile.drawerListTile(
                context, FlutterI18n.translate(
                context, "drawer.inicio"), currentRoute, Home.route,
                icon: Icons.home),
            const Divider(
              color: Colors.white,
            ),
            _drawerListTile.drawerListTile(context, FlutterI18n.translate(
                context, "drawer.sair"), currentRoute, 'sair',
                icon: null),
          ],
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return StreamBuilder<LoginModel>(
        stream: blocLogin.outLoginData,
        builder: (context, snapshot) {
          LoginModel login = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return SizedBox();
            case ConnectionState.active:
              return UserAccountsDrawerHeader(
                accountName: Text(login.nome),
                accountEmail: Text(login.login),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Color.fromARGB(255, 243, 112, 33)
                          : Colors.white,
                  child: Text(
                    login.login.substring(0, 1),
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 080, 079, 081),
                ),
                margin: EdgeInsets.all(0.0),
              );
            default:
              return Row(children: <Widget>[
                Text(FlutterI18n.translate(
                    context, "drawer.msgErroAoBuscarLogin")),
                Text("${snapshot.error}")
              ],);
          }
        }
    );
  }
}
