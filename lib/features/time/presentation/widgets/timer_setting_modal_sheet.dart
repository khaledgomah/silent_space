import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';
import 'package:silent_space/generated/l10n.dart';

class TimerSettingModalSheet extends StatefulWidget {
  const TimerSettingModalSheet({super.key});

  @override
  State<TimerSettingModalSheet> createState() => _TimerSettingModalSheetState();
}

class _TimerSettingModalSheetState extends State<TimerSettingModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: context.height() * 0.4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {},
                  icon: const Text(''),
                ),
                Text(
                  S.of(context).timerSettings,
                  style: TextStyleManager.bodyText1,
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).focusDuration,
                    style: TextStyleManager.bodyText1,
                  ),
                  Text(
                    BlocProvider.of<TimerCubit>(context)
                        .durationTime
                        .toString(),
                    style: TextStyleManager.bodyText1,
                  ),
                ],
              ),
            ),
            Slider(
              //Working Slider
              value:
                  BlocProvider.of<TimerCubit>(context).durationTime.toDouble(),
              min: 10,
              max: 180,
              divisions: 90,
              onChanged: (value) {
                setState(() {
                  BlocProvider.of<TimerCubit>(context).durationTime =
                      value.round();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).breakDuration,
                    style: TextStyleManager.bodyText1,
                  ),
                  Text(
                    BlocProvider.of<TimerCubit>(context).breakTime.toString(),
                    style: TextStyleManager.bodyText1,
                  ),
                ],
              ),
            ),
            Slider(
              //Break Slider
              value: BlocProvider.of<TimerCubit>(context).breakTime.toDouble(),
              min: 2,
              max: 30,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  BlocProvider.of<TimerCubit>(context).breakTime =
                      value.round();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).soundLevel,
                    style: TextStyleManager.bodyText1,
                  ),
                  Text(
                    BlocProvider.of<TimerCubit>(context).voiceLevel.toString(),
                    style: TextStyleManager.bodyText1,
                  ),
                ],
              ),
            ),
            Slider(
              //Break Slider
              value: BlocProvider.of<TimerCubit>(context).voiceLevel.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,

              onChanged: (value) {
                setState(() {
                  BlocProvider.of<TimerCubit>(context).voiceLevel =
                      value.round();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
