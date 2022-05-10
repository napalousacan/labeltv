import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/configs/size_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:labeltv/pages/splash.dart';
import 'package:wakelock/wakelock.dart';

Future main() async {
  Wakelock.enable();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(

      new LayoutBuilder(   // Add LayoutBuilder
          builder: (context, constraints) {
            return OrientationBuilder(   // Add OrientationBuilder
                builder: (context, orientation) {
                  SizeConfi().init(constraints, orientation); // SizeConfig initialization

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Malikia TV',
                    localizationsDelegates: [GlobalMaterialLocalizations.delegate],
                    supportedLocales: [
                      //const Locale('en'),
                      const Locale('fr')
                    ],
                    theme: new ThemeData(
                      primaryColor: Colors.blue[800],
                      accentColor: Colors.blue,
                      // Define the default font family.
                      fontFamily: 'CeraPro',
                      pageTransitionsTheme: PageTransitionsTheme(builders: {
                        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      }),
                    ),
                    home: new SplashScreen(),
                    builder: EasyLoading.init(),
                  );
                }
            );
          }
      )

  );
}