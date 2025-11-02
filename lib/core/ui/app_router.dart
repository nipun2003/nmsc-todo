import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/core/ui/custom_transition.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/di/app_module.dart';
import 'package:nmsc_todo/domain/use_cases/login_use_case.dart';
import 'package:nmsc_todo/domain/use_cases/register_use_case.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/events/register_events.dart';
import 'package:nmsc_todo/presentation/layouts/auth_layout.dart';
import 'package:nmsc_todo/presentation/notifier/auth_layout_notifier.dart';
import 'package:nmsc_todo/presentation/notifier/auth_notifier.dart';
import 'package:nmsc_todo/presentation/notifier/login_notifier.dart';
import 'package:nmsc_todo/presentation/notifier/register_notifier.dart';
import 'package:nmsc_todo/presentation/screens/auth/login_screen.dart';
import 'package:nmsc_todo/presentation/screens/auth/register_screen.dart';
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
        ShellRoute(
          builder: (context, state, child) {
            final signIn = GoogleSignIn.instance;
            final clientId = dotenv.env["GOOGLE_CLIENT_ID"] ?? "";
            final serverClientId = dotenv.env["GOOGLE_SERVER_CLIENT_ID"] ?? "";
            final eventBus = locator<LoginEventBus>();
            final supabaseAuthService = locator<SupabaseAuthService>();
            return ChangeNotifierProvider(
              create: (context) => AuthLayoutNotifier(
                googleSignIn: signIn,
                clientId: clientId,
                serverClientId: serverClientId,
                authService: supabaseAuthService,
                eventBus: eventBus,
              )..initializeGoogleSignInAndListen(),
              child: AuthLayout(child: child),
            );
          },
          routes: [
            GoRoute(
              path: "/auth/login",
              pageBuilder: (context, state) {
                final loginUseCase = locator<LoginUseCase>();
                final eventBus = locator<LoginEventBus>();
                final screen = ChangeNotifierProvider(
                  create: (context) => LoginNotifier(
                    loginUseCase: loginUseCase,
                    eventBus: eventBus,
                  ),
                  child: const LoginScreen(),
                );
                return buildSlideTransitionPage(
                  state: state,
                  child: screen,
                  key: ValueKey("Login"),
                );
              },
            ),
            GoRoute(
              path: "/auth/register",
              pageBuilder: (context, state) {
                 final registerUseCase = locator<RegisterUseCase>();
                final eventBus = locator<RegisterEventBus>();
                final screen = ChangeNotifierProvider(
                  create: (context) => RegisterNotifier(
                    registerUseCase: registerUseCase,
                    eventBus: eventBus,
                  ),
                  child: const RegisterScreen(),
                );
                return buildSlideTransitionPage(
                  state: state,
                  child: screen,
                  key: const ValueKey("Register"),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
