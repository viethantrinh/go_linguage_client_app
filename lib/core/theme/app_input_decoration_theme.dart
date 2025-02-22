import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInputDecorationTheme {
  static OutlineInputBorder _border([Color color = AppColor.line]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1),
      );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColor.surface,
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    enabledBorder: _border(),
    focusedBorder: _border(AppColor.secondary2),
    errorBorder: _border(AppColor.critical),
    focusedErrorBorder: _border(AppColor.critical),
    hintStyle: GoogleFonts.notoSans(
      color: AppColor.secondary2,
      height: 1,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}
