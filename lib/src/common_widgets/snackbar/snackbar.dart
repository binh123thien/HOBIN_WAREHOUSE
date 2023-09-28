import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class SnackBarWidget {
  static void showSnackBar(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: whiteColor,
        backgroundColor: color,
        content: Text(text),
        duration: const Duration(seconds: 2), // Thời gian hiển thị
      ),
    );
  }
}
