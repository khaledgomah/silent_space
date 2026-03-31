import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/home/presentation/widgets/show_data_container.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails({
    super.key,
    required this.focusMinutes,
    required this.sessionCount,
  });
  final int focusMinutes;
  final int sessionCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShowDataContainer(
            title: AppStrings.focusTime.tr(),
            value: '$focusMinutes ${AppStrings.minutes.tr()}',
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ShowDataContainer(
            title: AppStrings.focusCount.tr(),
            value: sessionCount.toString(),
            icon: Icons.check_circle_outline,
          ),
        ),
      ],
    );
  }
}
