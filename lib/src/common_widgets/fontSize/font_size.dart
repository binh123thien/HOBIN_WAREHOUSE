import 'package:flutter/material.dart';

class Font {
  static const double small = 0.036;
  static const double medium = 0.040;
  static const double large = 0.042;

  static List<double> sizes(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSmall = screenWidth * small;
    final double fontMedium = screenWidth * medium;
    final double fontLarge = screenWidth * large;

    return [fontSmall, fontMedium, fontLarge];
  }
}
