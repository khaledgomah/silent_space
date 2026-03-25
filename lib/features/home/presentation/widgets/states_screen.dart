import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/home/presentation/widgets/focus_chart.dart';
import 'package:silent_space/features/home/presentation/widgets/show_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is SessionLoaded && state.sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.query_stats,
                    size: 100, color: Theme.of(context).disabledColor),
                const SizedBox(height: 24),
                Text(
                  AppStrings.noSessionsTitle.tr(),
                  style: TextStyleManager.headline2,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.noSessionsSubtitle.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                AppStrings.today.tr(),
                style: TextStyleManager.headline2,
              ),
              const SizedBox(height: 8),
              const ShowDetails(),
              const SizedBox(height: 48),
              Text(
                AppStrings.summary.tr(),
                style: TextStyleManager.headline2,
              ),
              const SizedBox(height: 8),
              const ShowDetails(),
              const SizedBox(height: 48),
              Text(
                AppStrings.focusTime.tr(),
                style: TextStyleManager.headline2,
              ),
              const SizedBox(height: 8),
              const FocusChart(),
            ],
          ),
        );
      },
    );
  }
}
