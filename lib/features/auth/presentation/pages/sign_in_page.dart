import 'package:flutter/material.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_field.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng nhập tài khoản',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 42),
              AuthField(
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 20),
              AuthField(
                hintText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline,
                controller: passwordController,
                isObsecure: true,
              ),
              const SizedBox(height: 20),
              AuthButton(buttonText: 'Đăng nhập', formKey: _formKey, onPressFn: () {}),
              const SizedBox(height: 12),
              Text(
                'Quên mật khẩu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
      ),
    );
  }
}
