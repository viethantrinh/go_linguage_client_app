import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_option_button.dart';
import 'package:go_linguage/features/auth/presentation/widgets/term_privacy_text.dart';
import 'package:go_router/go_router.dart';

class SignUpOptionPage extends StatelessWidget {
  const SignUpOptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                'Theo dõi tiến độ học tập của bạn',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Tạo tài khoản để lưu tiến độ học tập của bạn',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Expanded(child: SizedBox()),
              Image.asset('assets/images/img_sign_up_option.png'),
              Expanded(child: SizedBox()),
              AuthOptionButton(
                buttonText: 'Tiếp tục với Facebook',
                assetPath: 'assets/icons/icon_facebook_auth.png',
                onPressFn: () {
                  // TODO: facebook auth
                },
              ),
              const SizedBox(height: 12),
              AuthOptionButton(
                buttonText: 'Tiếp tục với Google',
                assetPath: 'assets/icons/icon_google_auth.png',
                onPressFn: () {
                  // TODO: google auth
                },
              ),
              const SizedBox(height: 12),
              AuthOptionButton(
                buttonText: 'Đăng ký với email',
                onPressFn: () {
                  context.push(AppRoutePath.signUp);
                },
              ),
              const SizedBox(height: 40),
              TermPrivacyText(),
              if (Platform.isAndroid) const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
