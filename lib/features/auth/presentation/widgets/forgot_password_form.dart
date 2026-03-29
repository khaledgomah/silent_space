import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/widgets/custom_snack_bar.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          CustomSnackBar.showError(context, state.error);
        } else if (state is ForgotPasswordRequestSuccess) {
          CustomSnackBar.showSuccess(context, state.message);
          Navigator.pushReplacementNamed(context, RoutesName.resetPassword);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.forgotPasswordTitle.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              AppStrings.forgotPasswordDesc.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s40),
            AuthEmailField(controller: _emailController),
            const Spacer(),
            BlocSelector<ForgotPasswordCubit, ForgotPasswordState, bool>(
              selector: (state) => state is ForgotPasswordLoading,
              builder: (context, isLoading) {
                return AuthSubmitButton(
                  isLoading: isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ForgotPasswordCubit>().requestPasswordReset(
                            _emailController.text.trim(),
                          );
                    }
                  },
                  text: AppStrings.resetPasswordTitle.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
