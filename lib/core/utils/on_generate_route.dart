import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/features/setting/presentation/about_app_screen.dart';
import 'package:silent_space/features/setting/presentation/categories_screen.dart';
import 'package:silent_space/features/setting/presentation/feedback.dart';
import 'package:silent_space/features/setting/presentation/how_to_use_screen.dart';
import 'package:silent_space/features/splash/presentation/views/splash_view.dart';
import 'package:silent_space/features/home/presentation/manager/cubit/timer_cubit.dart';
import 'package:silent_space/features/home/presentation/views/home_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splash:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case RoutesName.homeView:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => TimerCubit(), child: const HomeView()));
    case RoutesName.howToUse:
      return MaterialPageRoute(builder: (context) => const HowToUseScreen());
    case RoutesName.categories:
      return MaterialPageRoute(builder: (context) => const CategoriesScreen());
    case RoutesName.feedbackScreen:
      return MaterialPageRoute(builder: (context) => FeedbackScreen());
    case RoutesName.aboutApp:
      return MaterialPageRoute(builder: (context) => const AboutAppScreen());
    default:
      return MaterialPageRoute(builder: (context) => const _UnknownPage());
  }
}

class _UnknownPage extends StatelessWidget {
  const _UnknownPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Page'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}

class RoutesName {
  static const String splash = '/';
  static const String unknown = '/unknown';
  static const String homeView = '/home';
  static const String howToUse = '/howToUse';
  static const String categories = '/categories';
  static const String aboutApp = '/aboutApp';
  static const String feedbackScreen = '/FeedbackScreen';
}
