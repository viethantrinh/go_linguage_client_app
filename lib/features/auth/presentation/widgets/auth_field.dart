import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
  });

  final String hintText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColor.secondary2, size: 20),
      ),
    );
  }
}
