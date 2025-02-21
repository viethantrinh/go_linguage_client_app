import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 42),
            AuthField(hintText: 'Email', prefixIcon: Icons.email_outlined),
            const SizedBox(height: 20),
            AuthField(hintText: 'Mật khẩu', prefixIcon: Icons.lock_outline),
            const SizedBox(height: 20),
            AuthButton(buttonText: 'Đăng nhập'),
            const SizedBox(height: 12),
            Text('Quên mật khẩu', style: themeData.textTheme.bodyLarge),
            const SizedBox(height: 32),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'Bằng cách tạo một tài khoản, bạn hoàn toàn đồng ý \nvới GoLinguage ',
                style: themeData.textTheme.labelSmall!.copyWith(),
                children: [
                  TextSpan(
                    text: 'Điều khoản',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  TextSpan(text: ' để '),
                  TextSpan(
                    text: 'Bảo mật',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
