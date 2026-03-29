import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.logifyBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.logifyWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is ForgotPasswordResetSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.resetPasswordTitle.tr(),
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.resetPasswordDesc.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // ── New Password ──
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
                    // ── Submit ──
                    AuthSubmitButton(
                      isLoading: state is ForgotPasswordLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().resetPassword(
                                widget.token,
                                _passwordController.text,
                              );
                        }
                      },
                      text: AppStrings.submitNewPassword.tr(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
