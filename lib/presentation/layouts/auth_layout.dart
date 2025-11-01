import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/core/ui/snackbar.dart';
import 'package:nmsc_todo/presentation/components/google_login.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/notifier/auth_layout_notifier.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatefulWidget {
  final Widget child;
  const AuthLayout({super.key, required this.child});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  late StreamSubscription<LoginEvent> _loginEventSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<AuthLayoutNotifier>();

      _loginEventSubscription = notifier.loginEvents.listen((event) {
        if (!mounted) return;

        switch (event) {
          case LoginSuccessEvent():
            SnackbarUtils.showSimpleSnackbar(context, 'Login Successful 🎉');
            break;
          case LoginErrorEvent(:final message):
            SnackbarUtils.showSimpleSnackbar(context, 'Login Failed: $message');
            break;
        }
      });

      notifier.attemptLightweightGoogleAuth();
    });
  }

  @override
  void dispose() {
    _loginEventSubscription.cancel();
    super.dispose();
  }

  // In auth_layout.dart, inside _AuthLayoutState's build method:

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AuthLayoutNotifier>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          // Used for overlaying the loading indicator
          alignment: Alignment.center,
          children: [
            // 1. Main Content Area (Scrollable Screen + Google Button)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.x_4,
                vertical: AppSize.x_8,
              ),
              child: Column(
                children: [
                  // Flexible takes up all available space for the child content.
                  // This ensures the Google button is pushed to the bottom.
                  Expanded(
                    child: widget
                        .child, // LoginScreen or RegisterScreen slides here
                  ),

                  // 2. Google Button (This part STAYS PUT)
                  if (GoogleSignIn.instance.supportsAuthenticate()) ...[
                    const SizedBox(height: AppSize.x_4),
                    GoogleLogin(
                      onClick: () async {
                        await notifier.signInWithGoogle();
                      },
                    ),
                  ],
                ],
              ),
            ),

            // 3. Loading Indicator Overlay
            if (notifier.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
