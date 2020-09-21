import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/services.dart';
import 'app.dart';
import 'bloc/bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // HttpOverrides.global = TestFairy.httpOverrides();

  /*runZonedGuarded(
    () async {
      try {
        FlutterError.onError =
            (details) => TestFairy.logError(details.exception);

        // Call `await TestFairy.begin()` or any other setup code here.

        runApp(CupertinoStoreApp());
      } catch (error) {
        TestFairy.logError(error);
      }
    },
    (e, s) {
      TestFairy.logError(e);
    },
    zoneSpecification: new ZoneSpecification(
      print: (self, parent, zone, message) {
        TestFairy.log(message);
      },
    )
  );*/
  return runApp(CupertinoStoreApp());
}

class CupertinoStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TriggerBloc>(
        create: (context) => TriggerBloc(),
        child: CupertinoApp(
            locale: Locale("ru", "RU"),
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            onGenerateRoute: (settings) {},
            theme: CupertinoThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[800],
                textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(color: Colors.black))),
            home: PlatformChannel()));
  }
}
