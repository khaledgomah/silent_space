import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/widgets/custom_text_field.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomUnderlineTextField(
      controller: controller,
      label: AppStrings.email.tr(),
      hintText: AppStrings.emailHint.tr(),
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.fieldRequired.tr();
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
          return AppStrings.invalidEmail.tr();
        }
        return null;
      },
    );
  }
}
