import 'package:flutter/material.dart';
import 'package:go_linguage/core/routes/app_route.dart';
import 'package:go_linguage/core/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLightData,
      routerConfig: AppRoute.router,
    );
  }
}
