import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String linkText;
  final VoidCallback onLinkTap;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLogo(),
        const SizedBox(height: AppSpacing.s32),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: AppSpacing.s4),
            GestureDetector(
              onTap: onLinkTap,
              child: Text(
                linkText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
