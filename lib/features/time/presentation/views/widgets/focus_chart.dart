import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/constans.dart';

class FocusChart extends StatelessWidget {
  const FocusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Constans.secondaryColor,
      ),
      height: context.screenHeight() * 0.3,
      child: Chart(layers: [
        ChartAxisLayer(
          settings: const ChartAxisSettings(
            x: ChartAxisSettingsAxis(
              frequency: -1.0,
              max: 0,
              min: 6.0,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 25,
              max: 100.0,
              min: 0.0,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
          labelX: (value) => getDate(value),
          labelY: (value) => value.toInt().toString(),
        ),
        ChartBarLayer(
          items: List.generate(
            7,
            (index) => ChartBarDataItem(
              color: const Color(0xFF8043F9),
              value: Random().nextInt(100).toDouble(),
              x: index.toDouble(),
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
