import 'package:flutter/material.dart';
import 'package:silent_space/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:silent_space/features/home/presentation/widgets/states_screen.dart';
import 'package:silent_space/features/setting/presentation/setting_screen.dart';
import 'package:silent_space/features/time/presentation/timer_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const TimerView(key: ValueKey('timer'));
      case 1:
        return const StatesScreen(key: ValueKey('stats'));
      case 2:
        return const SettingScreen(key: ValueKey('settings'));
      default:
        return const TimerView(key: ValueKey('timer'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _buildScreen(_currentIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
