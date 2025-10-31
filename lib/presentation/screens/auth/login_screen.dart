import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Import local components and files
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/core/ui/snackbar.dart';
import 'package:nmsc_todo/presentation/components/auth_logo.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/google_login.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/notifier/login_notifier.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // StreamSubscription for one-time login events
  late StreamSubscription<LoginEvent> _loginEventSubscription;

  @override
  void initState() {
    super.initState();
    // REFACTOR: Listener subscription is now done using addPostFrameCallback
    // to ensure the Notifier is available in the context.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginNotifier = context.read<LoginNotifier>();

      // Start listening to one-time events
      _loginEventSubscription = loginNotifier.loginEvents.listen((event) {
        if (!mounted) return;

        switch (event) {
          case LoginSuccessEvent():
            SnackbarUtils.showSimpleSnackbar(context, 'Login Successful! 🎉');
            // TODO: Navigate to Home screen
            break;
          case LoginErrorEvent(:final message):
            SnackbarUtils.showSimpleSnackbar(context, 'Login Failed: $message');
            break;
        }
      });

      // Start the lightweight authentication process after setup
      loginNotifier.attemptLightweightGoogleAuth();
    });
  }

  @override
  void dispose() {
    // REFACTOR: Ensure both the event stream and text controllers are canceled/disposed.
    // The Google stream is now managed and disposed inside the LoginNotifier.
    _loginEventSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // REFACTOR: Access Notifier with context.watch for rebuilds
    final loginNotifier = context.watch<LoginNotifier>();
    final isLoading = loginNotifier.isLoading;

    return Scaffold(
      // ... (Rest of the UI structure, which remains clean) ...
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSize.x_4,
            vertical: AppSize.x_8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSize.x_8),
                  const AuthLogo(),
                  const SizedBox(height: AppSize.x_14),
                  Text("Login", style: textTheme.headlineMedium),
                  const SizedBox(height: AppSize.x_8),
                  // Email Field
                  NmscEtField(
                    state: FieldState(validating: false),
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    type: TextFieldType.email,
                    labelText: "Email*",
                    controller: _emailController,
                  ),
                  const SizedBox(height: AppSize.x_5),
                  // Password Field
                  NmscEtField(
                    state: FieldState(validating: false),
                    hintText: "Enter your password",
                    keyboardType: TextInputType.visiblePassword,
                    type: TextFieldType.password,
                    labelText: "Password*",
                    controller: _passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NMSCTextButton(
                        text: "Forgot Password?",
                        onClick: () => {
                          // TODO: Implement forgot password navigation
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.x_5),
                  // Email/Password Login Button
                  NMSCPrimaryButton(
                    text: "Log in",
                    isFullWidth: true,
                    onClick: () => loginNotifier.login(
                      _emailController.text,
                      _passwordController.text,
                    ),
                    isLoading: isLoading,
                    isDisabled: isLoading,
                    type: NmscButtonType.primary,
                  ),
                  const SizedBox(height: AppSize.x_2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      NMSCTextButton(
                        text: "Register",
                        onClick: () => {
                          // TODO: Implement navigation to registration page
                        },
                      ),
                    ],
                  ),
                  if (GoogleSignIn.instance.supportsAuthenticate()) ...[
                    const SizedBox(height: AppSize.x_4),
                    // Google Login Button
                    GoogleLogin(
                      onClick: () async {
                        // REFACTOR: Now calls a simple method on the Notifier
                        // The Notifier handles the entire flow and error messages.
                        await loginNotifier.signInWithGoogle();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
