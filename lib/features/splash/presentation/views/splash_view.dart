import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/image_manager.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_state.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashCubit>()..checkAuth(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, RoutesName.homeView);
          } else if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, RoutesName.login);
          }
        },
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage(ImageManager.appIcon)),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.splashSubtitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ).tr(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
