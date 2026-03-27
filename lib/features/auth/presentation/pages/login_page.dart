import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_colors.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

import '../../../../core/utils/app_strings.dart';

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
                          AppStrings.loginTitle.tr(),
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
                          AppStrings.loginSubtitle.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.logifyGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // ── Email ──
                        AuthEmailField(controller: _emailController),
                        const SizedBox(height: 16),

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
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                  activeColor: AppColors.logifyPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                Text(
                                  AppStrings.rememberMe.tr(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.logifyDark),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RoutesName.forgotPassword);
                              },
                              child: Text(
                                AppStrings.forgotPassword.tr(),
                                style: const TextStyle(
                                  color: AppColors.logifyPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ── Submit Button ──
                        AuthSubmitButton(
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSubmit(cubit),
                          text: AppStrings.login.tr(),
                        ),
                        const SizedBox(height: 40),

                        // ── Divider ──
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                                    color: AppColors.logifyLightGrey,
                                    thickness: 1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                AppStrings.orContinueWith.tr(),
                                style: const TextStyle(
                                    color: AppColors.logifyGrey, fontSize: 14),
                              ),
                            ),
                            const Expanded(
                                child: Divider(
                                    color: AppColors.logifyLightGrey,
                                    thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ── Social Buttons ──
                        const SocialLoginButtons(),
                        const SizedBox(height: 40),

                        // ── Footer ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.noAccount.tr(),
                              style:
                                  const TextStyle(color: AppColors.logifyDark),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RoutesName.register);
                              },
                              child: Text(
                                AppStrings.register.tr(),
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
