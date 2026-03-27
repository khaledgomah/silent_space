import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/features/time/presentation/widgets/custom_count_down_timer.dart';
import 'package:silent_space/features/time/presentation/widgets/restart_icon_button.dart';
import 'package:silent_space/features/time/presentation/widgets/select_music_modal_sheet.dart';
import 'package:silent_space/features/time/presentation/widgets/start_and_pause_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/features/time/presentation/widgets/timer_setting_modal_sheet.dart';

class TimerView extends StatelessWidget {
  TimerView({super.key});
  final CountDownController _countDownController = CountDownController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withAlpha(25),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: context.width() * 0.05),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const SelectMusicSheet(),
                    );
                  },
                  icon: Icon(
                    FontAwesomeIcons.music,
                    color: iconColor,
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
                  icon: Icon(
                    FontAwesomeIcons.sliders,
                    color: iconColor,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.music_note,
                    color: iconColor,
                  )),
              SizedBox(width: context.width() * 0.05),
            ],
          ),
          const Spacer(),
          CustomCountDownTimer(countDownController: _countDownController),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StartAndPauseWidget(
                countDownController: _countDownController,
              ),
              SizedBox(
                width: context.width() * 0.2,
              ),
              RestartTimerIconButton(
                countDownController: _countDownController,
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
