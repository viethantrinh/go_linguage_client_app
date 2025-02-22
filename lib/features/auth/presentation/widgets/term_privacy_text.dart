import 'package:flutter/material.dart';

class TermPrivacyText extends StatelessWidget {
  const TermPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Bằng cách tạo một tài khoản, bạn hoàn toàn đồng ý \nvới GoLinguage ',
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
    );
  }
}
