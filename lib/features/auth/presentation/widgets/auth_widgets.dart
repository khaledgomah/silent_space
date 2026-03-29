import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/widgets/custom_button.dart';
import 'package:silent_space/core/widgets/custom_text_field.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Underline-style Email Field (LOGIFY Figma – Node 25-348)
// ─────────────────────────────────────────────────────────────────────────────

class AuthEmailField extends StatelessWidget {
  final TextEditingController controller;

  const AuthEmailField({super.key, required this.controller});

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
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(value.trim())) {
          return AppStrings.invalidEmail.tr();
        }
        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Underline-style Username Field
// ─────────────────────────────────────────────────────────────────────────────

class AuthUsernameField extends StatelessWidget {
  final TextEditingController controller;

  const AuthUsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomUnderlineTextField(
      controller: controller,
      label: AppStrings.username.tr(),
      hintText: AppStrings.usernameHint.tr(),
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.fieldRequired.tr();
        }
        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Underline-style Password Field with visibility toggle
// ─────────────────────────────────────────────────────────────────────────────

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.validator,
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
      hintText: AppStrings.passwordHint.tr(),
      prefixIcon: Icons.lock_outline,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          size: 20,
          color: AppColors.logifyGrey,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.fieldRequired.tr();
            }
            if (value.length < 4) {
              return AppStrings.passwordTooShort.tr();
            }
            return null;
          },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Magenta Pill Submit Button
// ─────────────────────────────────────────────────────────────────────────────

class AuthSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
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
      isLoading: isLoading,
      onPressed: onPressed,
      text: text,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circular Social Login Buttons (Facebook · Apple · Google)
// ─────────────────────────────────────────────────────────────────────────────

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircle(
          icon: FontAwesomeIcons.facebookF,
          color: AppColors.logifyFacebookBlue,
          onPressed: onFacebookPressed ?? () {},
        ),
        const SizedBox(width: 20),
        _buildCircle(
          icon: FontAwesomeIcons.apple,
          color: AppColors.logifyWhite,
          onPressed: onApplePressed ?? () {},
        ),
        const SizedBox(width: 20),
        _buildCircle(
          icon: FontAwesomeIcons.google,
          color: AppColors.logifyGoogleRed,
          onPressed: onGooglePressed ?? () {},
        ),
      ],
    );
  }

  Widget _buildCircle({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.logifyLightGrey, width: 1.5),
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
