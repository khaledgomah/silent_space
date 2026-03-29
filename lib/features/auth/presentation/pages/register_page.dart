import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(AuthCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      cubit.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.logifyBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pushReplacementNamed(
                      RoutesName.homeView,
                    );
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<AuthCubit>();
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 48),

                        // ── Logo ──
                        _buildLogo(),
                        const SizedBox(height: 32),

                        // ── Header ──
                        Text(
                          AppStrings.registerTitle.tr(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),

                        // ── Login link ──
                        Row(
                          children: [
                            Text(
                              AppStrings.hasAccount.tr(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                AppStrings.login.tr(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // ── Email ──
                        AuthEmailField(controller: _emailController),
                        const SizedBox(height: 24),

                        // ── Username ──
                        AuthUsernameField(controller: _nameController),
                        const SizedBox(height: 24),

                        // ── Password ──
                        AuthPasswordField(
                          controller: _passwordController,
                          label: AppStrings.password.tr(),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 24),

                        // ── Confirm Password ──
                        AuthPasswordField(
                          controller: _confirmPasswordController,
                          label: AppStrings.confirmPassword.tr(),
                          onFieldSubmitted: (val) => _onSubmit(cubit),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldRequired.tr();
                            }
                            if (value != _passwordController.text) {
                              return AppStrings.passwordMismatch.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 36),

                        // ── Submit Button ──
                        AuthSubmitButton(
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSubmit(cubit),
                          text: AppStrings.register.tr(),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        color: AppColors.logifyPrimary,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'S',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
