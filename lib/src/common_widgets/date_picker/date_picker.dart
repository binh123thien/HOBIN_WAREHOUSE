import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class MyTheme {
  static ThemeData getCustomDatePickerTheme(int phanBietNhapXuat) {
    Color primaryColor = phanBietNhapXuat == 1 ? blueColor : mainColor;
    Color onPrimaryColor = phanBietNhapXuat == 1 ? Colors.white : Colors.black;
    Color onSurfaceColor = phanBietNhapXuat == 1 ? Colors.black : Colors.white;
    Color textButtonColor = phanBietNhapXuat == 1 ? blueColor : mainColor;
    Color dialogBackgroundColor =
        phanBietNhapXuat == 1 ? Colors.white : Colors.grey;

    ThemeData datePickerTheme = ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        onSurface: onSurfaceColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textButtonColor,
        ),
      ),
      dialogBackgroundColor: dialogBackgroundColor,
    );

    return datePickerTheme;
  }
}
