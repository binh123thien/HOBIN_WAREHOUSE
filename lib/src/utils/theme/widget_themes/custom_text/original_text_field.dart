import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

const InputDecorationTheme noDecorationInputDecorationTheme =
    InputDecorationTheme(
  border: OutlineInputBorder(),
  errorBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  contentPadding: EdgeInsets.zero,
  prefixIconColor: mainColor,
  suffixIconColor: mainColor,
  floatingLabelStyle: TextStyle(color: mainColor),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: mainColor)),
  labelStyle: TextStyle(),
  helperStyle: TextStyle(),
  hintStyle: TextStyle(),
  errorStyle: TextStyle(),
  suffixStyle: TextStyle(),
  prefixStyle: TextStyle(),
);
