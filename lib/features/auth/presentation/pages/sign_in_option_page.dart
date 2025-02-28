import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_option_button.dart';
import 'package:go_linguage/features/auth/presentation/widgets/term_privacy_text.dart';
import 'package:go_router/go_router.dart';

class SignInOptionPage extends StatelessWidget {
  const SignInOptionPage({super.key});

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
              Text('Chào mừng trở lại', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Hãy sẵn sàng để tiếp tục hành trình học ngôn ngữ của bạn',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox()),
              Image.asset('assets/images/img_sign_in_option.png'),
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
                buttonText: 'Đăng nhập với email',
                onPressFn: () {
                  context.push(AppRoutePath.signIn);
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
