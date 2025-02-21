import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/core/theme/app_input_decoration_theme.dart';
import 'package:go_linguage/core/theme/app_typography.dart';

class AppTheme {
  static final ThemeData themeLightData = ThemeData(
    useMaterial3: true,
    textTheme: AppTypography.textTheme,
    primaryTextTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColor.white,
    inputDecorationTheme: AppInputDecorationTheme.inputDecorationTheme,
  );
}
