import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
              } else if (state is ForgotPasswordRequestSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.pushReplacementNamed(
                    context, RoutesName.resetPassword);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.forgotPasswordTitle.tr(),
                      style: const TextStyle(
                        color: AppColors.logifyWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.forgotPasswordDesc.tr(),
                      style: const TextStyle(
                        color: AppColors.logifyGrey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // ── Email ──
                    AuthEmailField(controller: _emailController),
                    const Spacer(),
                    // ── Submit ──
                    AuthSubmitButton(
                      isLoading: state is ForgotPasswordLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<ForgotPasswordCubit>()
                              .requestPasswordReset(
                                _emailController.text.trim(),
                              );
                        }
                      },
                      text: AppStrings.resetPasswordTitle.tr(),
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
