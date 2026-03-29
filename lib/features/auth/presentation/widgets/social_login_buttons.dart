import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/theme/app_spacing.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: FontAwesomeIcons.google,
          color: AppColors.logifyPrimary,
          onPressed: onGooglePressed ?? () {},
        ),
        const SizedBox(width: AppSpacing.s24),
        _SocialButton(
          icon: FontAwesomeIcons.apple,
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: onApplePressed ?? () {},
        ),
        const SizedBox(width: AppSpacing.s24),
        _SocialButton(
          icon: FontAwesomeIcons.facebook,
          color: Colors.blue,
          onPressed: onFacebookPressed ?? () {},
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: AppSpacing.s48,
        height: AppSpacing.s48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
