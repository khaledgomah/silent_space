import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.tooltip});
  final Icon icon;
  final VoidCallback onPressed;
  final String? tooltip;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      tooltip: tooltip,
      color: Theme.of(context).colorScheme.onSurface,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
