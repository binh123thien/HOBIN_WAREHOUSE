import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class TTextTheme {
  TTextTheme._(); //to avoid creating instances

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
        color: darkColor, fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: GoogleFonts.inter(
        color: darkColor, fontSize: 19, fontWeight: FontWeight.w500),
    bodySmall: GoogleFonts.inter(
        color: darkColor, fontSize: 18, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.inter(
        color: darkColor, fontSize: 17, fontWeight: FontWeight.w500),
    titleMedium: GoogleFonts.inter(
        color: darkColor, fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(
        color: darkColor, fontSize: 15, fontWeight: FontWeight.w500),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
        color: darkColor, fontSize: 28, fontWeight: FontWeight.w800),
    bodyMedium: GoogleFonts.inter(
        color: darkColor, fontSize: 24, fontWeight: FontWeight.w700),
    bodySmall: GoogleFonts.inter(
        color: darkColor, fontSize: 20, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.inter(
        color: darkColor, fontSize: 18, fontWeight: FontWeight.w300),
    titleMedium: GoogleFonts.inter(
        color: darkColor, fontSize: 16, fontWeight: FontWeight.w300),
    titleSmall: GoogleFonts.inter(
        color: darkColor, fontSize: 14, fontWeight: FontWeight.w300),
  );
}
