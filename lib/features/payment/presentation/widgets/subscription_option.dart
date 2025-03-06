import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class SubscriptionOption extends StatelessWidget {
  final String period;
  final String price;
  final String perMonth;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionOption({
    super.key,
    required this.period,
    required this.price,
    required this.perMonth,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected
                  ? Border.all(color: AppColor.primary500, width: 2)
                  : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: AppColor.secondary2.withAlpha(40),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(period, style: Theme.of(context).textTheme.titleMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (perMonth.isNotEmpty)
                  Text(
                    perMonth,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColor.secondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
