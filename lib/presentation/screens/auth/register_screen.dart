



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/presentation/components/auth_logo.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSize.x_8),
            const AuthLogo(),
            const SizedBox(height: AppSize.x_14),
        
            Text("Register", style: textTheme.headlineMedium),
            const SizedBox(height: AppSize.x_8),
        
            // --- Email Field ---
            NmscEtField(
              hintText: "Enter your email",
              labelText: "Email*",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: null,
              onChanged: (value) {
                // Handle email validation
              },
            ),
            const SizedBox(height: AppSize.x_5),
        
            // --- Password Field ---
            NmscEtField(
              hintText: "Enter your password",
              labelText: "Password*",
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscure: true,
              errorText: null,
              onChanged: (value) {
                // Handle password validation
              },
            ),
            const SizedBox(height: AppSize.x_4),
        
            NmscButton(
              text: "Sign Up",
              fullWidth: true,
              isDisabled: false,
              isLoading: false,
              onPressed: () {
                // Handle login action
              },
            ),
            const SizedBox(height: AppSize.x_2),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                NMSCTextButton(text: "Log in", onClick: () {
                  context.pop();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}