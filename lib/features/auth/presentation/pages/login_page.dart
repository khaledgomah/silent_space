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
                        const SizedBox(height: 20),
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
                              'L',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Header ──
                        const Text(
                          'Log in to your Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.logifyDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // ── Email ──
                        AuthEmailField(controller: _emailController),
                        const SizedBox(height: 16),

                        // ── Password ──
                        AuthPasswordField(
                          controller: _passwordController,
                          label: AppStrings.password.tr(),
                          onFieldSubmitted: (val) => _onSubmit(cubit),
                        ),
                        const SizedBox(height: 12),

                        // ── Remember Me & Forgot ──
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v!),
                              activeColor: AppColors.logifyPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const Text('Remember me'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style:
                                    TextStyle(color: AppColors.logifyPrimary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── Submit Button ──
                        AuthSubmitButton(
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSubmit(cubit),
                          text: 'Log In',
                        ),
                        const SizedBox(height: 32),

                        // ── Divider ──
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: AppColors.logifyGrey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ── Social Buttons ──
                        const SocialLoginButtons(),
                        const SizedBox(height: 32),

                        // ── Footer ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RoutesName.register);
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
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
