import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/presentation/components/auth_logo.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_text_button.dart';
import 'package:nmsc_todo/presentation/components/google_login.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/components/buttons/nmsc_primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
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
                const SizedBox(height: AppSize.x_4),
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
                    NMSCTextButton(text: "Forgot Password?", onClick: () => {}),
                  ],
                ),
                const SizedBox(height: AppSize.x_5),
                NMSCPrimaryButton(
                  text: "Log in",
                  isFullWidth: true,
                  onClick: () => {},
                  isLoading: false,
                  isDisabled: false,
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
                const SizedBox(height: AppSize.x_4),
                GoogleLogin(onClick: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
