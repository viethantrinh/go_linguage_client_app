import 'package:flutter/material.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 42),
            AuthField(
              hintText: 'Tên',
              prefixIcon: Icons.account_circle_outlined,
            ),
            const SizedBox(height: 20),
            AuthField(hintText: 'Email', prefixIcon: Icons.email_outlined),
            const SizedBox(height: 20),
            AuthField(hintText: 'Mật khẩu', prefixIcon: Icons.lock_outline),
            const SizedBox(height: 20),
            AuthField(
              hintText: 'Xác nhận mật khẩu',
              prefixIcon: Icons.lock_outline,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Đăng ký')),
            RichText(text: TextSpan(text: 'ngu', children: [])),
          ],
        ),
      ),
    );
  }
}
