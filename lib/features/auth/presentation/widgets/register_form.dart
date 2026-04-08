import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/theme/app_spacing.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/widgets/custom_snack_bar.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/widgets/auth_widgets.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
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
              title: AppStrings.registerTitle.tr(),
              subtitle: AppStrings.hasAccount.tr(),
              linkText: AppStrings.login.tr(),
              onLinkTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.s40),
            AuthEmailField(controller: _emailController),
            const SizedBox(height: AppSpacing.s24),
            AuthUsernameField(controller: _nameController),
            const SizedBox(height: AppSpacing.s24),
            AuthPasswordField(
              controller: _passwordController,
              label: AppStrings.password.tr(),
              hintText: AppStrings.passwordHint.tr(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.s24),
            AuthPasswordField(
              controller: _confirmPasswordController,
              label: AppStrings.confirmPassword.tr(),
              hintText: AppStrings.confirmPasswordHint.tr(),
              onFieldSubmitted: (val) => _onSubmit(context),
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
            const SizedBox(height: AppSpacing.s36),
            BlocSelector<AuthCubit, AuthState, bool>(
              selector: (state) => state is AuthLoading,
              builder: (context, isLoading) {
                return AuthSubmitButton(
                  isLoading: isLoading,
                  onPressed: () => _onSubmit(context),
                  text: AppStrings.register.tr(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s32),
          ],
        ),
      ),
    );
  }
}
