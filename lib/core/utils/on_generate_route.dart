import 'package:flutter/material.dart';
import 'package:silent_space/features/auth/presentation/pages/login_page.dart';
import 'package:silent_space/features/auth/presentation/pages/register_page.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silent_space/features/setting/presentation/about_app_screen.dart';
import 'package:silent_space/features/setting/presentation/categories_screen.dart';
import 'package:silent_space/features/setting/presentation/feedback.dart';
import 'package:silent_space/features/setting/presentation/how_to_use_screen.dart';
import 'package:silent_space/features/splash/presentation/views/splash_view.dart';
import 'package:silent_space/features/home/presentation/views/home_view.dart';
import 'package:silent_space/core/utils/page_transitions.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splash:
      return FadePageRoute(page: const SplashView());
    case RoutesName.login:
      return FadePageRoute(page: const LoginPage());
    case RoutesName.register:
      return FadePageRoute(page: const RegisterPage());
    case RoutesName.homeView:
      return FadePageRoute(page: const HomeView());
    case RoutesName.howToUse:
      return SlidePageRoute(page: const HowToUseScreen());
    case RoutesName.categories:
      return SlidePageRoute(page: const CategoriesScreen());
    case RoutesName.feedbackScreen:
      return SlidePageRoute(page: FeedbackScreen());
    case RoutesName.aboutApp:
      return SlidePageRoute(page: const AboutAppScreen());
    default:
      return SlidePageRoute(page: const _UnknownPage());
  }
}

class _UnknownPage extends StatelessWidget {
  const _UnknownPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.unknownPage.tr()),
      ),
      body: Center(
        child: Text(AppStrings.pageNotFound.tr()),
      ),
    );
  }
}

class RoutesName {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String unknown = '/unknown';
  static const String homeView = '/home';
  static const String howToUse = '/howToUse';
  static const String categories = '/categories';
  static const String aboutApp = '/aboutApp';
  static const String feedbackScreen = '/FeedbackScreen';
}
