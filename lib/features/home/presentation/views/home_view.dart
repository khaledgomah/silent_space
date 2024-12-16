import 'package:flutter/material.dart';
import 'package:silent_space/features/setting/presentation/setting_sceen.dart';
import 'package:silent_space/features/home/presentation/widgets/states_screen.dart';
import 'package:silent_space/features/time/presentation/timer_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _screens = [
    TimerView(),
    const StatesScreen(),
    const SettingSceen()
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          currentIndex: currentIndex,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: const Icon(
                  Icons.timer,
                ),
              ),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: const Icon(
                  Icons.bar_chart,
                ),
              ),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: const Icon(
                  Icons.settings,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: _screens[currentIndex]));
  }
}
