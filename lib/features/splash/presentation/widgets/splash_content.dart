import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/image_manager.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(ImageManager.appIcon)),
            const SizedBox(height: AppSpacing.s24),
            Text(
              AppStrings.splashSubtitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ).tr(),
          ],
        ),
      ),
    );
  }
}
