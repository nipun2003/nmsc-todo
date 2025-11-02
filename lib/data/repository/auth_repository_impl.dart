import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/core/utils/extensions.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/domain/models/login_result.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/utils/enums/login_error_type.dart';
import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';
import 'package:nmsc_todo/domain/utils/exception/register_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthService _authService;
  AuthRepositoryImpl({required SupabaseAuthService authService})
    : _authService = authService;

  @override
  Future<LoginResult> loginWithEmail(String email, String password) async {
    try {
      if(kDebugMode){
        print("Attempting login for Email: $email");
      }
      final userId = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if(kDebugMode){
        print("Login successful for User ID: $userId");
      }
      return LoginSuccess(userId);
    } catch (e) {
      return LoginFailure(LoginErrorType.unknownError, message: e.toString());
    }
  }

  @override
  Future<String> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async{
   try {
      final userId = await _authService.signUpWithEmailAndPassword(
        email:  email,
        password: password,
        fullName: name,
      );
      if(kDebugMode){
        print("Registration successful for User ID: $userId");
      }
      return userId;
    }on AuthException catch (e) {
      if(kDebugMode){
        print("Registration failed for Email: $email - AuthException: ${e.message}");
      }
      final RegisterErrorType errorType = e.getRegisterErrorType();
      throw RegisterException(errorType, e.getMessage());
    } catch (e) {
      if(kDebugMode){
        print("Registration failed for Email: $email - Error: type $e instance ${e.runtimeType}");
      }
      throw RegisterException(RegisterErrorType.unknown, e.toString());
    }
  }
}
