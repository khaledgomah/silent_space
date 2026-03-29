import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/widgets/custom_snack_bar.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class ResetPasswordForm extends StatefulWidget {
  final String token;
  const ResetPasswordForm({super.key, required this.token});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          CustomSnackBar.showError(context, state.error);
        } else if (state is ForgotPasswordResetSuccess) {
          CustomSnackBar.showSuccess(context, state.message);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.resetPasswordTitle.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              AppStrings.resetPasswordDesc.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s40),
            AuthPasswordField(
              controller: _passwordController,
              label: AppStrings.newPassword.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.fieldRequired.tr();
                }
                if (value.length < 6) {
                  return AppStrings.passwordMinLength6.tr();
                }
                return null;
              },
            ),
            const Spacer(),
            BlocSelector<ForgotPasswordCubit, ForgotPasswordState, bool>(
              selector: (state) => state is ForgotPasswordLoading,
              builder: (context, isLoading) {
                return AuthSubmitButton(
                  isLoading: isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ForgotPasswordCubit>().resetPassword(
                            widget.token,
                            _passwordController.text,
                          );
                    }
                  },
                  text: AppStrings.submitNewPassword.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
