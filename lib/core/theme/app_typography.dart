import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme = TextTheme(
    // display text style
    displayLarge: GoogleFonts.notoSans(
      fontSize: 57,
      height: 64 / 57,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.notoSans(
      fontSize: 45,
      height: 52 / 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.notoSans(
      fontSize: 36,
      height: 44 / 36,
      fontWeight: FontWeight.w400,
    ),

    // headline text style
    headlineLarge: GoogleFonts.notoSans(
      fontSize: 40,
      height: 40 / 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.notoSans(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.notoSans(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w400,
    ),

    // title text style
    titleLarge: GoogleFonts.notoSans(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: GoogleFonts.notoSans(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.notoSans(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
    ),

    // body text style
    bodyLarge: GoogleFonts.notoSans(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.notoSans(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.notoSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
    ),
    
    // label text style
    labelLarge: GoogleFonts.notoSans(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.notoSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.notoSans(
      fontSize: 12,
      height: 26 / 12,
      fontWeight: FontWeight.w500,
    ),
  );
}
