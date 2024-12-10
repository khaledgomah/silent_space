import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/image_manager.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _timer;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timer = Timer(
        const Duration(
          seconds: 2,
        ),
        () => Navigator.pushReplacementNamed(context, '/home'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageManager.appIcon),
            const Text(
              'Have a silent space',
              style: TextStyleManager.headline1,
            ),
          ],
        ),
      ),
    );
  }
}
