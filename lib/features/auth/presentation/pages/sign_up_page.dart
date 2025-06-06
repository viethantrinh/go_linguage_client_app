import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/loading_indicator.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_field.dart';
import 'package:go_linguage/features/auth/presentation/widgets/term_privacy_text.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSucess) {
          context.go(AppRoutePath.home);
        } else if (state is AuthFailure) {
          final snackBar = SnackBar(content: Text(state.message));

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Đăng ký tài khoản',
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
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 42),
                  AuthField(
                    hintText: 'Tên',
                    prefixIcon: Icons.account_circle_outlined,
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
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
                  AuthButton(
                    buttonText: 'Đăng ký',
                    onPressFn: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthSignUp(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      context.go(AppRoutePath.onBoard);
                      context.push(AppRoutePath.signInOption);
                      context.push(AppRoutePath.signIn);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Bạn đã có tài khoản? ',
                        style: themeData.textTheme.bodyLarge!.copyWith(
                          color: AppColor.secondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Đăng nhập',
                            style: themeData.textTheme.bodyLarge!.copyWith(
                              color: AppColor.primary600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TermPrivacyText(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
