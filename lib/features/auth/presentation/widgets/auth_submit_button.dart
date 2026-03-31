import 'package:flutter/material.dart';
import 'package:silent_space/core/widgets/custom_button.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
  });
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
