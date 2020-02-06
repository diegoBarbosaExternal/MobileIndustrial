import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:sugar/src/blocs/login_bloc.dart';
import 'package:sugar/src/blocs/produto_bloc.dart';
import 'package:sugar/src/blocs/sugar_bloc.dart';
import 'package:sugar/src/blocs/tipo_acucar_bloc.dart';
import 'package:sugar/src/blocs/tipo_usina_bloc.dart';
import 'package:sugar/src/blocs/turno_bloc.dart';
import 'package:sugar/src/blocs/usina_bloc.dart';
import 'package:sugar/src/ui/home/home.dart';
import 'package:sugar/src/ui/pages/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(BlocProvider(
      tagText: 'sugarGlobal',
      child: SugarApp(),
      blocs: [
        Bloc((i) => SugarBloc()),
        Bloc((i) => LoginBloc()),
        Bloc((i) => ProdutoBloc()),
        Bloc((i) => TipoUsinaBloc()),
        Bloc((i) => UsinaBloc()),
        Bloc((i) => DropDowBlocTurno()),
        Bloc((i) => TipoAcucarBloc()),

      ],
    ));
  });
}

class SugarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Login(),
        title: 'Sugar',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          FlutterI18nDelegate(path: 'assets/i18n', fallbackFile: 'en'),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt'), // Português
          const Locale('en'), // English
          const Locale('es'), // Spanish
        ],
        routes: <String, WidgetBuilder>{
          Home.route: (context) => Home(),
        }
    );
  }
}
