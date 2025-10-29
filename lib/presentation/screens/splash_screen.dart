import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        BuildContext,
        Widget,
        Placeholder,
        StatefulWidget,
        State,
        Navigator,
        CircularProgressIndicator,
        Scaffold;
import 'package:nmsc_todo/presentation/screens/auth/login_page.dart';
import 'package:nmsc_todo/presentation/screens/home_page.dart';

import 'package:nmsc_todo/core/ui/size.dart';
import 'package:nmsc_todo/core/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if (session == null) {
      print("No user session, redirecting to login page");
      Navigator.of(
        context,
      ).pushAndRemoveUntil(LoginPage.route(), (route) => false);
    } else {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(HomePage.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/logo.png",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            CircularProgressIndicator(),
            const SizedBox(height: AppSize.x_3),
            Text("Loading Data..."),
          ],
        ),
      ),
    );
  }
}
