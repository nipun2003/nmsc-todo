import 'package:nmsc_todo/domain/models/login_result.dart';

abstract class AuthRepository {
  Future<LoginResult> loginWithEmail(String email, String password);

  Future<String> registerWithEmail(
    {
      required String name,
      required String email,
      required String password,
    }
  );
}
