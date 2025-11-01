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

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AuthLayoutNotifier>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children:[ SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.x_4,
                vertical: AppSize.x_8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.child,
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
            if (notifier.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
