

import 'package:flutter/material.dart';

Builder goToButton({required String namedRoute, required String text}) {
  return Builder(builder: (context) {

    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
        onPressed: (){
          Navigator.of(context).pushNamed(namedRoute);
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(text, style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: size.width/10),),
        ));
  },);
}