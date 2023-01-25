import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:some_from_all/screens/home.dart';

import 'developSettings/VariableHolder.dart';
import 'screens/applications/qrScannerScreen.dart';

void main() {
	SystemChrome.setPreferredOrientations([
    		DeviceOrientation.portraitUp,
    		DeviceOrientation.portraitDown
  	]);
  runApp(
      const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Some From All",
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: ColorPalette.color1,),
        primarySwatch: ColorPalette.materialColor1,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: ColorPalette.materialColor2),
        textTheme: TextTheme(
          headline1: GoogleFonts.lato(letterSpacing: 0, fontSize: 24, fontWeight: FontWeight.bold),
          bodyText1: GoogleFonts.newsreader(height: 1.5, fontSize: 16),
          subtitle1: GoogleFonts.openSans(fontSize: 12),
        ),
      ),
      home: const Home(),

      routes: {
        QrScannerScreen.routeName : (context) => const QrScannerScreen(), // "/QrScannerScreen"
      },

    );
  }
}


