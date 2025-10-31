import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/presentation/components/auth_logo.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/google_login.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/notifier/login_notifier.dart';
import 'package:provider/provider.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/contacts.readonly',
];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => LoginNotifier(),
        child: LoginPage(),
      ),
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _contactText = '';
  String _errorMessage = '';

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };
    if (kDebugMode) {
      print(
        "Google user${user == null ? ' signed out' : ' signed in: ${user.email}'}",
      );
    }
    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization
  }

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      _errorMessage = e is GoogleSignInException
          ? _errorMessageFromSignInException(e)
          : 'Unknown error: $e';
    });
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    // In practice, an application should likely have specific handling for most
    // or all of the, but for simplicity this just handles cancel, and reports
    // the rest as generic errors.
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }

  @override
  void initState() {
    super.initState();
    final GoogleSignIn signIn = GoogleSignIn.instance;
    final clientId = dotenv.env["GOOGLE_CLIENT_ID"] ?? "";
    final serverClientId = dotenv.env["GOOGLE_SERVER_CLIENT_ID"] ?? "";
    unawaited(
      signIn
          .initialize(clientId: clientId, serverClientId: serverClientId)
          .then((_) {
            signIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);

            signIn.attemptLightweightAuthentication();
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final loginNotifier = context.watch<LoginNotifier>();
    final isLoading = loginNotifier.isLoading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 32,
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
                  NmscEtField(
                    state: FieldState(validating: false),
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    type: TextFieldType.email,
                    labelText: "Email*",
                    controller: _emailController,
                  ),
                  const SizedBox(height: AppSize.x_5),
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
                        onClick: () => {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.x_5),
                  NMSCPrimaryButton(
                    text: "Log in",
                    isFullWidth: true,
                    onClick: () => {
                      loginNotifier.login(
                        _emailController.text,
                        _passwordController.text,
                      ),
                    },
                    isLoading: isLoading,
                    isDisabled: isLoading,
                    type: NmscButtonType.primary,
                  ),
                  const SizedBox(height: AppSize.x_2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),

                      NMSCTextButton(text: "Register", onClick: () => {}),
                    ],
                  ),
                  if (GoogleSignIn.instance.supportsAuthenticate())
                    const SizedBox(height: AppSize.x_4),
                  if (GoogleSignIn.instance.supportsAuthenticate())
                    GoogleLogin(
                      onClick: () async {
                        try {
                          await GoogleSignIn.instance.authenticate();
                        } catch (e) {
                          _errorMessage = e.toString();
                        }
                      },
                    ),
                  const SizedBox(height: AppSize.x_4),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  if (_contactText.isNotEmpty)
                    Text(_contactText, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
