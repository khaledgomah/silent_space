import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';

class RememberMeCheckbox extends StatefulWidget {
  const RememberMeCheckbox({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: AppSpacing.s24,
          width: AppSpacing.s24,
          child: Checkbox(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v ?? false);
              widget.onChanged(_value);
            },
            activeColor: AppColors.logifyPrimary,
            checkColor: AppColors.logifyWhite,
            side: const BorderSide(
              color: AppColors.logifyGrey,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.s4),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Text(
          AppStrings.rememberMe.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
