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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        // ── Logo ──
                        Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.logifyPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Header ──
                        Text(
                          AppStrings.registerTitle.tr(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.logifyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // ── Subtitle ──
                        Text(
                          AppStrings.registerSubtitle.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.logifyGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // ── Username / Name ──
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: AppStrings.username.tr(),
                            hintStyle: const TextStyle(
                                color: AppColors.logifyGrey, fontSize: 14),
                            prefixIcon: const Icon(Icons.person_outline,
                                size: 20, color: AppColors.logifyPrimary),
                            filled: true,
                            fillColor: AppColors.logifyLightGrey,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: AppColors.logifyPrimary, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Email ──
                        AuthEmailField(controller: _emailController),
                        const SizedBox(height: 16),

                        // ── Password ──
                        AuthPasswordField(
                          controller: _passwordController,
                          label: AppStrings.password.tr(),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 32),

                        // ── Submit Button ──
                        AuthSubmitButton(
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSubmit(cubit),
                          text: AppStrings.register.tr(),
                        ),
                        const SizedBox(height: 40),

                        // ── Footer ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.hasAccount.tr(),
                              style:
                                  const TextStyle(color: AppColors.logifyDark),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                AppStrings.login.tr(),
                                style: const TextStyle(
                                  color: AppColors.logifyPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
}
