import 'package:flutter/material.dart';
import 'package:silent_space/core/widgets/custom_text_field.dart';

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomUnderlineTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: 'Enter your ${widget.label}',
      obscureText: _obscure,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: 20,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
    );
  }
}
