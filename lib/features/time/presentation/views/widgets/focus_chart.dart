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
              frequency: 1.0,
              max: 13.0,
              min: 7.0,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
            y: ChartAxisSettingsAxis(
              frequency: 100.0,
              max: 300.0,
              min: 0.0,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
          labelX: (value) => value.toString(),
          labelY: (value) => value.toString(),
        ),
        ChartBarLayer(
          items: List.generate(
            13 - 7 + 1,
            (index) => ChartBarDataItem(
              color: const Color(0xFF8043F9),
              value: Random().nextInt(280) + 20,
              x: index.toDouble() + 7,
            ),
          ),
          settings: const ChartBarSettings(
            thickness: 8.0,
            radius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ]),
    );
  }
}
