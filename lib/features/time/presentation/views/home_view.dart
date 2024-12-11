import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/constans.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/data/models/setting_item_model.dart';
import 'package:silent_space/features/time/presentation/views/widgets/states_screen.dart';
import 'package:silent_space/features/time/presentation/views/widgets/timer_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _screens = [
    TimerScreen(),
    const StatesScreen(),
    SettingSceen()
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

class SettingSceen extends StatelessWidget {
  SettingSceen({super.key});
  final List<SettingItemModel> settingItems = [
    SettingItemModel(title: 'Dark Mode', icon: const Icon(Icons.dark_mode)),
    SettingItemModel(
        title: 'Notifications', icon: const Icon(Icons.notifications)),
    SettingItemModel(title: 'About', icon: const Icon(Icons.info)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 50, left: 18),
          child: Text(
            'General',
            style: TextStyleManager.headline2,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: settingItems.length,
          itemBuilder: (context, index) =>
              SettingItemWidget(item: settingItems[index]),
        ),
      ],
    );
  }
}

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({super.key, required this.item});

  final SettingItemModel item;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Constans.secondaryColor),
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
      ),
      onPressed: () {},
      child: ListTile(
        leading: item.icon,
        title: Text(item.title),
      ),
    );
  }
}
