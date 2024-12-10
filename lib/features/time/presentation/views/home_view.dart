import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/timer_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final maxTime = 1000;
  final CountDownController _countDownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Home'),
      ),
      body: TimerSection(countDownController: _countDownController, maxTime: maxTime),
    );
  }
}
