import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    this.hintText,
    super.key,
    this.onSaved,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.autovalidateMode,
    this.initalValue,
    this.borderRadius,
    required this.controller,
  });
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final String? initalValue;
  final String? hintText;
  final double? borderRadius;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initalValue,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 155, 165, 244)),
          ),
          border: const OutlineInputBorder(),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white)),
    );
  }
}
