

import 'package:flutter/material.dart';
import 'package:some_from_all/developSettings/MaterialColorCreator.dart';

class CustomUsed{
  static String title = "Some_From_All";
  static String authorName = "Şükrü Özgün Demirel";

}

class ColorPalette {
  static Color color1 = const Color(0xFFFAE39A);
  static MaterialColor materialColor1 = createMaterialColor(const Color(
      0xFF151C25));
  static MaterialColor materialColor2 = createMaterialColor(const Color(
      0xFF7D7C5B),);
  static MaterialColor materialColor3 = createMaterialColor(const Color(
      0xFF353C35),);
  static MaterialColor materialColor4 = createMaterialColor(const Color(
      0xFF2B3D3D),);

  static MaterialColor highlightedColor = createMaterialColor(Color(0xFF45A88E),);

}

class PaddingConstants {
  static double smallPaddingConstant = 1/20;
  static double mediumPaddingConstant = 1/15;
  static double largePaddingConstant = 1/10;
}