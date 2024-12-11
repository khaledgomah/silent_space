import 'package:flutter/material.dart';

class TimerSettingModalSheet extends StatefulWidget {
  const TimerSettingModalSheet({super.key});

  @override
  State<TimerSettingModalSheet> createState() => _TimerSettingModalSheetState();
}

class _TimerSettingModalSheetState extends State<TimerSettingModalSheet> {
  double _sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(child: Text('Timer Settings')),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          divisions: 100,
          label: _sliderValue.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
      ],
    );
  }
}
