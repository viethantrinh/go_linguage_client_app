import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final bool showBorder;
  final Widget? trailing;

  const SettingItem({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onTap,
    this.showBorder = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: AppColor.line,
                ),
              )
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Expanded(child: SizedBox()),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
          ],
        ),
      ),
    );
  }
} 