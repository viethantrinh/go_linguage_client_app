import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class SubscriptionFeature extends StatelessWidget {
  final String feature;

  const SubscriptionFeature({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            feature,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColor.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
