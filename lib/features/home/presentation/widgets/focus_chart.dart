import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/helper/helper_functions.dart';

class FocusChart extends StatelessWidget {
  final List<int> weeklyMinutes;

  const FocusChart({super.key, required this.weeklyMinutes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textStyle = TextStyle(
      color: theme.colorScheme.onSurface,
      fontSize: 10.0,
    );

    final maxValue = weeklyMinutes.isEmpty ? 0 : weeklyMinutes.reduce((a, b) => a > b ? a : b);
    final yMax = maxValue <= 0 ? 30.0 : ((maxValue / 30).ceil() * 30).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withAlpha(50)
            : Colors.white,
        border: Border.all(
          color: AppColors.navBarIndicator.withValues(alpha: isDark ? 0.1 : 0.05),
          width: 1,
        ),
      ),
      height: context.height() * 0.3,
      child: Chart(layers: [
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: 1.0,
              max: 6.0,
              min: 0.0,
              textStyle: textStyle.copyWith(color: theme.hintColor),
            ),
            y: ChartAxisSettingsAxis(
              frequency: yMax / 3,
              max: yMax,
              min: 0.0,
              textStyle: textStyle.copyWith(color: theme.hintColor),
            ),
          ),
          labelX: (value) => getDate((6 - value.toInt()).toDouble()),
          labelY: (value) => value.toInt().toString(),
        ),
        ChartBarLayer(
          items: List.generate(
            7,
            (index) => ChartBarDataItem(
              color: AppColors.navBarActive,
              value: weeklyMinutes[6 - index].toDouble(),
              x: index.toDouble(),
            ),
          ),
          settings: const ChartBarSettings(
            thickness: 12.0,
            radius: BorderRadius.vertical(top: Radius.circular(6.0)),
          ),
        ),
      ]),
    );
  }
}
