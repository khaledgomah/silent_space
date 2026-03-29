import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
