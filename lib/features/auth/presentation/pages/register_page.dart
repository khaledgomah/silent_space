import 'package:flutter/material.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
