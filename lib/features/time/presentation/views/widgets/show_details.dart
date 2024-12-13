import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/show_data_container.dart';
import 'package:silent_space/generated/l10n.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShowDataContainer(title: S.of(context).focusTime, value: 10),
        const SizedBox(width: 16),
        ShowDataContainer(title: S.of(context).focusCount, value: 1),
      ],
    );
  }
}
