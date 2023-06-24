import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  // light theme
  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: mainColor,
          suffixIconColor: mainColor,
          floatingLabelStyle: TextStyle(color: mainColor),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: mainColor)));

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: mainColor,
          suffixIconColor: mainColor,
          floatingLabelStyle: TextStyle(color: mainColor),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: mainColor)));
}
