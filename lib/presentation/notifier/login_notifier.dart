import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';

const List<String> scopes = <String>[
  "email",
  "profile"
];

class LoginNotifier extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void login(String email, String password) async {
    if (isLoading) return;
    setLoading(true);
    // Simulate a login process with a delay
    await Future.delayed(const Duration(seconds: 2));
    // Here you would typically call your authentication service
    setLoading(false);
  }

  void handleGoogleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (isLoading) return;
    setLoading(true);
    try {
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
      final idToken = user?.authentication.idToken;
      if (kDebugMode) {
        print('ID Token: $idToken');
      }
      if (idToken == null) {
        return;
      }
      // Check for existing authorization.
      // #docregion CheckAuthorization
      final GoogleSignInClientAuthorization? authorization = await user
          ?.authorizationClient
          .authorizationForScopes(scopes);
      if (authorization == null) {
        if (kDebugMode) {
          print('Authorization is null');
        }
        return;
      }
      final authorizationToken = authorization.accessToken;
      await supabaseAuthService.signInWithGoogle(idToken, authorizationToken);
    } finally {
      setLoading(false);
    }
  }
}
