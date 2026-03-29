import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(AuthCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      cubit.signIn(
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
                          AppStrings.loginTitle.tr(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.logifyWhite,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ── Register link ──
                        Row(
                          children: [
                            Text(
                              AppStrings.noAccount.tr(),
                              style: const TextStyle(
                                color: AppColors.logifyGrey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(RoutesName.register),
                              child: Text(
                                AppStrings.register.tr(),
                                style: const TextStyle(
                                  color: AppColors.logifyPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // ── Email ──
                        AuthEmailField(controller: _emailController),
                        const SizedBox(height: 24),

                        // ── Password ──
                        AuthPasswordField(
                          controller: _passwordController,
                          label: AppStrings.password.tr(),
                          onFieldSubmitted: (val) => _onSubmit(cubit),
                        ),
                        const SizedBox(height: 16),

                        // ── Remember Me & Forgot ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) => setState(
                                        () => _rememberMe = v ?? false),
                                    activeColor: AppColors.logifyPrimary,
                                    checkColor: AppColors.logifyWhite,
                                    side: const BorderSide(
                                      color: AppColors.logifyGrey,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.rememberMe.tr(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.logifyWhite,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, RoutesName.forgotPassword),
                              child: Text(
                                AppStrings.forgotPassword.tr(),
                                style: const TextStyle(
                                  color: AppColors.logifyGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // ── Submit Button ──
                        AuthSubmitButton(
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSubmit(cubit),
                          text: AppStrings.login.tr(),
                        ),
                        const SizedBox(height: 36),

                        // ── Divider ──
                        _buildOrDivider(),
                        const SizedBox(height: 28),

                        // ── Social Buttons ──
                        const SocialLoginButtons(),
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

  // ── Shared Helpers ──

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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.logifyLightGrey.withValues(alpha: .5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.orContinueWith.tr(),
            style: const TextStyle(color: AppColors.logifyGrey, fontSize: 13),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.logifyLightGrey.withValues(alpha: .5),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
