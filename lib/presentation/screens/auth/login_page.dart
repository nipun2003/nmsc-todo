import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/presentation/components/google_login.dart';
import 'package:nmsc_todo/presentation/components/nmsc_et_field.dart';
import 'package:nmsc_todo/presentation/components/nmsc_primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/logo.png",
                width: 80,
                height: 80,
                alignment: AlignmentGeometry.bottomCenter,
                fit: BoxFit.fill,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSize.x_2),
                  Text("Login to continue", style: textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: AppSize.x_12),
              NmscEtField(
                label: "Email Address",
                hintText: "Enter your email",
                type: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSize.x_5),
              NmscEtField(
                label: "Password",
                hintText: "Enter your password",
                type: TextInputType.visiblePassword,
                isPassword: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => {},
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
              NmscPrimaryButton(
                title: "Log In",
                onPressed: () => {},
                full: true,
              ),
              const SizedBox(height: AppSize.x_2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),

                  TextButton(
                    onPressed: () => {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.x_3,
                        horizontal: 0,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text("Register"),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.x_4),
              GoogleLogin(onPressed: () => {}),
            ],
          ),
        ),
      ),
    );
  }
}
