import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class SubscriptionButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onSubscribe;

  const SubscriptionButton({
    super.key,
    required this.buttonText,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.primary500,
      ),
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.transparentColor,
          shadowColor: AppColor.transparentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onSubscribe,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
