import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/core/theme/app_typography.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    textTheme: AppTypography.textTheme,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.primary500,
      onPrimary: AppColor.white,
      secondary: AppColor.secondary,
      onSecondary: AppColor.white,
      error: AppColor.critical,
      onError: AppColor.white,
      surface: AppColor.surface,
      onSurface: AppColor.onSurface,
    ),
    scaffoldBackgroundColor: AppColor.white,
  );
}
