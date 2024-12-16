import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/features/time/presentation/widgets/custom_count_down_timer.dart';
import 'package:silent_space/features/time/presentation/widgets/restart_icon_button.dart';
import 'package:silent_space/features/time/presentation/widgets/start_and_puase_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/features/time/presentation/widgets/timer_setting_modal_sheet.dart';

class TimerScreen extends StatelessWidget {
  TimerScreen({super.key});
  final maxTime = 30;
  final CountDownController _countDownController = CountDownController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: context.width() * 0.05),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.music,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const TimerSettingModalSheet();
                    },
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.sliders,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                )),
            SizedBox(width: context.width() * 0.05),
          ],
        ),
        const Spacer(),
        CustomCountDownTimer(
            countDownController: _countDownController, maxTime: maxTime),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StartAndPuaseWidget(
              countDownController: _countDownController,
            ),
            SizedBox(
              width: context.width() * 0.2,
            ),
            RestartTimerIconButton(
              countDownController: _countDownController,
              maxTime: maxTime,
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
