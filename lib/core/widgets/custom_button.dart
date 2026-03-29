import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;

  const CustomButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    this.text,
    this.child,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : (child ?? Text(text!)),
    );
  }
}
