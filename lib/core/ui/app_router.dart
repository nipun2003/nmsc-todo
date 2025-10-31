import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/presentation/notifier/auth_notifier.dart';
import 'package:nmsc_todo/presentation/notifier/login_notifier.dart';
import 'package:nmsc_todo/presentation/screens/auth/login_screen.dart';
import 'package:nmsc_todo/presentation/screens/home_screen.dart';
import 'package:nmsc_todo/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: "/splash",
      refreshListenable: context.read<AuthNotifier>(),
      redirect: (context, state) {
        final auth = context.read<AuthNotifier>();
        if (auth.isCheckingSession) return null;

        final loggedIn = auth.isLoggedIn;
        final isSplash = state.uri.toString() == "/splash";
        final isLoggingIn = state.uri.toString().startsWith("/auth");

        // If not logged in, move to login
        if (!loggedIn && !isLoggingIn) return "/auth/login";

        // If logged in, skip login page and splash
        if (loggedIn && (isSplash || isLoggingIn)) return "/";

        return null;
      },
      routes: [
        GoRoute(
          path: "/splash",
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: "/auth/login",
          builder: (context, state) {
            final signIn = GoogleSignIn.instance;
            final clientId = dotenv.env["GOOGLE_CLIENT_ID"] ?? "";
            final serverClientId = dotenv.env["GOOGLE_SERVER_CLIENT_ID"] ?? "";
            return ChangeNotifierProvider(
              create: (context) => LoginNotifier(
                googleSignIn: signIn,
                clientId: clientId,
                serverClientId: serverClientId,
                authService: supabaseAuthService,
              )..initializeGoogleSignInAndListen(),
              child: const LoginScreen(),
            );
          },
        ),
      ],
    );
  }
}
