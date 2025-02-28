import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColor.primary700),
      ),
    );
  }
}
