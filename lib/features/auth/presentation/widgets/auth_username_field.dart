import 'package:flutter/material.dart';
import 'package:silent_space/core/widgets/custom_text_field.dart';

class AuthUsernameField extends StatelessWidget {
  const AuthUsernameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomUnderlineTextField(
      controller: controller,
      label: 'Full Name',
      hintText: 'Enter your full name',
      prefixIcon: Icons.person_outline,
    );
  }
}
