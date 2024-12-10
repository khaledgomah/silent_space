import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/states_screen.dart';
import 'package:silent_space/features/time/presentation/views/widgets/timer_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

List<Widget> _screens = [
  TimerScreen(),
  const StatesScreen(),
  const Placeholder()
];
