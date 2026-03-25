import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/home/presentation/widgets/show_data_container.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShowDataContainer(title: AppStrings.focusTime.tr(), value: 10),
        const SizedBox(width: 16),
        ShowDataContainer(title: AppStrings.focusCount.tr(), value: 1),
      ],
    );
  }
}
