import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor:
                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.timer_outlined),
                selectedIcon: Icon(Icons.timer,
                    color: Theme.of(context).colorScheme.primary),
                label: AppStrings.focusTime.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary),
                label: AppStrings.summary.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.primary),
                label: AppStrings.generalSettings.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
