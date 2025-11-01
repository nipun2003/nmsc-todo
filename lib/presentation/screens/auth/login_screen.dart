import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/presentation/components/auth_logo.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/notifier/login_notifier.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<LoginNotifier>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isDisabled =
        notifier.isLoading ||
        notifier.emailError != null ||
        notifier.passwordError != null ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSize.x_8),
        const AuthLogo(),
        const SizedBox(height: AppSize.x_14),

        Text("Login", style: textTheme.headlineMedium),
        const SizedBox(height: AppSize.x_8),

        // --- Email Field ---
        NmscEtField(
          hintText: "Enter your email",
          labelText: "Email*",
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          errorText: notifier.emailError,
          onChanged: notifier.validateEmail,
        ),
        const SizedBox(height: AppSize.x_5),

        // --- Password Field ---
        NmscEtField(
          hintText: "Enter your password",
          labelText: "Password*",
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscure: true,
          errorText: notifier.passwordError,
          onChanged: notifier.validatePassword,
        ),
        const SizedBox(height: AppSize.x_4),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [NMSCTextButton(text: "Forgot Password?", onClick: () {})],
        ),
        const SizedBox(height: AppSize.x_5),

        NmscButton(
          text: "Log in",
          fullWidth: true,
          isDisabled: isDisabled,
          isLoading: notifier.isLoading,
          onPressed: () {
            notifier.login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
          },
        ),
        const SizedBox(height: AppSize.x_2),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? "),
            NMSCTextButton(text: "Register", onClick: () {}),
          ],
        ),
      ],
    );
  }
}
