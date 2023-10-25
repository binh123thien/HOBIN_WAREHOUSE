import 'package:flutter/material.dart';

class Font {
  static const double size1 = 0.036;
  static const double size2 = 0.040;
  static const double size3 = 0.044;
  static const double size4 = 0.048;
  static const double size5 = 0.052;

  static List<double> sizes(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double font1 = screenWidth * size1;
    final double font2 = screenWidth * size2;
    final double font3 = screenWidth * size3;
    final double font4 = screenWidth * size4;
    final double font5 = screenWidth * size5;
    return [font1, font2, font3, font4, font5];
  }
}
