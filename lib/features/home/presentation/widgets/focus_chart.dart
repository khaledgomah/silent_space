import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:silent_space/core/helper/helper_functions.dart';

class FocusChart extends StatelessWidget {
  final List<int> weeklyMinutes;

  const FocusChart({super.key, required this.weeklyMinutes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: theme.colorScheme.onSurface,
      fontSize: 10.0,
    );

    final maxValue = weeklyMinutes.reduce(max);
    // Round up to nearest 30 for nice axis, minimum 30
    final yMax = maxValue <= 0 ? 30.0 : ((maxValue / 30).ceil() * 30).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primaryContainer.withAlpha(50),
      ),
      height: context.height() * 0.3,
      child: Chart(layers: [
        ChartAxisLayer(
          settings: ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: -1.0,
              max: 0,
              min: 6.0,
              textStyle: textStyle,
            ),
            y: ChartAxisSettingsAxis(
              frequency: yMax / 4,
              max: yMax,
              min: 0.0,
              textStyle: textStyle,
            ),
          ),
          labelX: (value) => getDate(value),
          labelY: (value) => value.toInt().toString(),
        ),
        ChartBarLayer(
          items: List.generate(
            7,
            (index) => ChartBarDataItem(
              color: theme.colorScheme.primary,
              value: weeklyMinutes[index].toDouble(),
              x: (6 - index).toDouble(),
            ),
          ),
          settings: const ChartBarSettings(
            thickness: 10.0,
            radius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ]),
    );
  }
}
