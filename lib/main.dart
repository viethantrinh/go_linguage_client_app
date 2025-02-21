import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_theme.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_up_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLightData,
      home: Scaffold(appBar: AppBar(), body: SignUpPage()),
    );
  }
}
