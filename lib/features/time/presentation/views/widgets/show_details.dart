import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/show_data_container.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShowDataContainer(title: 'Focas Time (min)', value: 10),
        SizedBox(width: 16),
        ShowDataContainer(title: 'Focus count', value: 1),
      ],
    );
  }
}
