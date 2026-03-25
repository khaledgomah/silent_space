import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/home/presentation/widgets/focus_chart.dart';
import 'package:silent_space/features/home/presentation/widgets/show_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class StatesScreen extends StatefulWidget {
  const StatesScreen({super.key});

  @override
  State<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionCubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        // ── Loading ──
        if (state is SessionLoading || state is SessionInitial) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(AppStrings.loadingStats.tr()),
              ],
            ),
          );
        }

        // ── Error ──
        if (state is SessionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 80, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(AppStrings.statsError.tr(),
                    style: TextStyleManager.headline2),
                const SizedBox(height: 8),
                Text(state.message,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () =>
                      context.read<SessionCubit>().loadSessions(),
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.retry.tr()),
                ),
              ],
            ),
          );
        }

        // ── Loaded but empty ──
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

        // ── Loaded with data ──
        final loaded = state as SessionLoaded;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Today Section ──
              Text(AppStrings.today.tr(), style: TextStyleManager.headline2),
              const SizedBox(height: 8),
              ShowDetails(
                focusMinutes: loaded.todayMinutes,
                sessionCount: loaded.todayCount,
              ),
              const SizedBox(height: 32),

              // ── All-Time Section ──
              Text(AppStrings.allTime.tr(), style: TextStyleManager.headline2),
              const SizedBox(height: 8),
              ShowDetails(
                focusMinutes: loaded.totalMinutes,
                sessionCount: loaded.totalCount,
              ),
              const SizedBox(height: 32),

              // ── Weekly Chart ──
              Text(AppStrings.weeklyOverview.tr(),
                  style: TextStyleManager.headline2),
              const SizedBox(height: 8),
              FocusChart(weeklyMinutes: loaded.weeklyMinutes),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
