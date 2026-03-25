import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/features/setting/presentation/setting_screen.dart';
import 'package:silent_space/features/home/presentation/widgets/states_screen.dart';
import 'package:silent_space/features/time/presentation/timer_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  static final List<Widget> _screens = [
    TimerView(),
    const StatesScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => getIt<SessionCubit>()..loadSessions(),
      child: Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: AppStrings.focusTime.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: AppStrings.summary.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppStrings.generalSettings.tr(),
          ),
        ],
      ),
      ),
    );
  }
}
