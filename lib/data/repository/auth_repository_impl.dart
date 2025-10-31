import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/domain/models/login_result.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/utils/enums/login_error_type.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthService _authService;
  AuthRepositoryImpl({required SupabaseAuthService authService})
    : _authService = authService;

  @override
  Future<LoginResult> loginWithEmail(String email, String password) async {
    try {
      final userId = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      return LoginSuccess(userId);
    } catch (e) {
      return LoginFailure(LoginErrorType.unknownError, message: e.toString());
    }
  }
}
