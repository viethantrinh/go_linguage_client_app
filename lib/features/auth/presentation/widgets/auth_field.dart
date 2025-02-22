import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class AuthField extends StatelessWidget {
  AuthField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.isObsecure = false,
  }) : _passwordVisible = ValueNotifier(!isObsecure);

  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isObsecure;
  final ValueNotifier<bool> _passwordVisible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _passwordVisible,
      builder: (context, isVisible, _) {
        return TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: AppColor.secondary2, size: 20),
            suffixIcon:
                isObsecure
                    ? IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColor.secondary2,
                        size: 20,
                      ),
                      onPressed: () => _passwordVisible.value = !_passwordVisible.value,
                    )
                    : null,
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          obscureText: !isVisible && isObsecure,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return '$hintText must not be empty';
            }
            return null;
          },
        );
      },
    );
  }
}
