import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  // light theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      elevation: 0,
      foregroundColor: whiteColor,
      backgroundColor: darkColor,
      side: const BorderSide(color: darkColor),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
  // dark theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      elevation: 0,
      foregroundColor: darkColor,
      backgroundColor: whiteColor,
      side: const BorderSide(color: darkColor),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
