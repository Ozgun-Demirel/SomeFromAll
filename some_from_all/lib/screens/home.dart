
import 'package:flutter/material.dart';

import '../screenSubWidgets/home/allButtonInfo.dart';
import '../screenSubWidgets/home/goToButtonTemplate.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Some From All"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: size.width/40, right: size.width/40, top: size.height/20, bottom: size.height/3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome to Some From All", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 40), textAlign: TextAlign.center),
            goToButton(namedRoute: QrScannerButtonInfo.route, text: QrScannerButtonInfo.buttonText),
          ],
        ),
      ),
    );
  }

}
