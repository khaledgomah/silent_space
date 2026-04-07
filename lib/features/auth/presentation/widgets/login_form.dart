import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/widgets/custom_snack_bar.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(RoutesName.homeView);
        } else if (state is AuthError) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s48),
            AuthHeader(
              title: AppStrings.loginTitle.tr(),
              subtitle: AppStrings.noAccount.tr(),
              linkText: AppStrings.register.tr(),
              onLinkTap: () =>
                  Navigator.of(context).pushNamed(RoutesName.register),
            ),
            const SizedBox(height: AppSpacing.s40),
            AuthEmailField(controller: _emailController),
            const SizedBox(height: AppSpacing.s24),
            AuthPasswordField(
              controller: _passwordController,
              label: AppStrings.password.tr(),
              onFieldSubmitted: (val) => _onSubmit(context),
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RememberMeCheckbox(onChanged: (v) {}),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesName.forgotPassword),
                  child: Text(
                    AppStrings.forgotPassword.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s36),
            BlocSelector<AuthCubit, AuthState, bool>(
              selector: (state) => state is AuthLoading,
              builder: (context, isLoading) {
                return AuthSubmitButton(
                  isLoading: isLoading,
                  onPressed: () => _onSubmit(context),
                  text: AppStrings.login.tr(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s36),
            const OrDivider(),
            const SizedBox(height: AppSpacing.s28),
            SocialLoginButtons(
              onGooglePressed: () => context.read<AuthCubit>().signInWithGoogle(),
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}
