import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';

class ShowDataContainer extends StatelessWidget {
  const ShowDataContainer({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  final String title;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withAlpha(50)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              AppColors.navBarIndicator.withValues(alpha: isDark ? 0.1 : 0.05),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.navBarIndicator.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: AppColors.navBarActive.withValues(alpha: 0.6),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyleManager.headline2.copyWith(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
