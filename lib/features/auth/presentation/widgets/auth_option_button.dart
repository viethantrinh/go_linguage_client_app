import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class AuthOptionButton extends StatelessWidget {
  const AuthOptionButton({
    super.key,
    required this.buttonText,
    required this.onPressFn,
    this.assetPath,
  });

  final String buttonText;
  final String? assetPath;
  final Function() onPressFn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.surface,
      ),
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.transparentColor,
          shadowColor: AppColor.transparentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressFn,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null) ...[
              Image.asset(assetPath!, width: 20, height: 20),
              SizedBox(width: 12),
            ] else ...[
              SizedBox(width: 22),
            ],
            Text(buttonText, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
