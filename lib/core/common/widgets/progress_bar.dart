import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class PercentageProgressBar extends StatelessWidget {
  final double percentage;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const PercentageProgressBar({
    super.key,
    required this.percentage,
    this.height = 5,
    this.backgroundColor = AppColor.line,
    this.progressColor = AppColor.primary500,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
