import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.logifyLightGrey.withValues(alpha: .5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Text(
            AppStrings.orContinueWith.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.logifyLightGrey.withValues(alpha: .5),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
