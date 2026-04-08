import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/helper/extensions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class TimerSettingModalSheet extends StatelessWidget {
  const TimerSettingModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
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
                    const SizedBox(width: 48),
                    Text(
                      AppStrings.timerSettings.tr(),
                      style: TextStyleManager.bodyText1,
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.focusDuration.tr(),
                        style: TextStyleManager.bodyText1,
                      ),
                      Text(
                        '${state.durationTime} min',
                        style: TextStyleManager.bodyText1,
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: state.durationTime.toDouble(),
                  min: 10,
                  max: 180,
                  divisions: 34,
                  onChanged: (value) {
                    context.read<TimerCubit>().setDurationTime(value.round());
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.soundLevel.tr(),
                        style: TextStyleManager.bodyText1,
                      ),
                      Text(
                        '${state.voiceLevel}%',
                        style: TextStyleManager.bodyText1,
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: state.voiceLevel.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    context.read<TimerCubit>().setVoiceLevel(value.round());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
