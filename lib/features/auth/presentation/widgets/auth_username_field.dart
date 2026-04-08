import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/widgets/custom_text_field.dart';

class AuthUsernameField extends StatelessWidget {
  const AuthUsernameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomUnderlineTextField(
      controller: controller,
      label: AppStrings.fullName.tr(),
      hintText: AppStrings.fullNameHint.tr(),
      prefixIcon: Icons.person_outline,
    );
  }
}
