import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  final double size;
  final Color? color;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CustomBackButton({
    super.key,
    this.size = 20,
    this.color,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {
        if (Navigator.canPop(context)) {
          context.pop();
        }
      },
      child: Icon(
        icon ?? Icons.arrow_back_ios_new,
        size: size,
        color: color ?? Colors.black,
      ),
    );
  }
}
