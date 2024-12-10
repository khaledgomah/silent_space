import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/timer_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final List<Color> blackShades = [
  const Color(0xFFA9A9A9), // Gray
  const Color(0xFFD3D3D3), // Light Gray
  const Color(0xFFE6E6E6), // Silver
  const Color(0xFFFFFFFF), // White (for contrast or end of gradient)
];

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurple,
                  Colors.purple
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: _screens[currentIndex]));
  }
}

List<Widget> _screens = [
  TimerScreen(),
  const Placeholder(),
  const Placeholder()
];

class TimerScreen extends StatelessWidget {
  TimerScreen({super.key});
  final maxTime = 30;
  final CountDownController _countDownController = CountDownController();
  @override
  Widget build(BuildContext context) {
    return TimerSection(
        countDownController: _countDownController, maxTime: maxTime);
  }
}

extension MediaQuerySize on BuildContext {
  double screenHeight() => MediaQuery.of(this).size.height;
  double screenWidth() => MediaQuery.of(this).size.width;
}
