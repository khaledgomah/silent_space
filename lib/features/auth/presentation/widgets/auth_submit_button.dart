import 'package:flutter/material.dart';
import 'package:silent_space/core/widgets/custom_button.dart';

class AuthSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const AuthSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
