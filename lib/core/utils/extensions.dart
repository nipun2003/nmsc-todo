


import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension AuthExceptionExtension on AuthException {


  RegisterErrorType getRegisterErrorType() {
    if(this is AuthWeakPasswordException){
      return RegisterErrorType.weakPassword;
    }
    final String? errorCodeString = this.code;
    if(kDebugMode){
      print('AuthException code: $errorCodeString');
    }
    if (errorCodeString == null) {
      // No error code usually means a generic exception (e.g., network failure)
      return RegisterErrorType.unknown; 
    }

    // Convert the error string to lowercase to ensure robust matching
    final String code = errorCodeString.toLowerCase();

    switch (code) {
      // 1. Weak Password
      case 'weak_password':
        return RegisterErrorType.weakPassword;
      case 'email_address_invalid':
        return RegisterErrorType.invalidEmail;

      // 2. Email Already in Use (Supabase can return a few codes for this)
      case 'email_exists':
      case 'user_already_exists':
        return RegisterErrorType.emailAlreadyInUse;
        
      // 3. Invalid Email Format (This is often covered by 'validation_failed' in Supabase)
      // Note: Mapping 'validation_failed' is speculative; if Supabase explicitly
      // returns a code for bad email *format*, that code should be used.
      // For now, we'll assume validation_failed is generic.
      // If you find a specific code for invalid format, add it here.
      
      // 4. Potential Network or Timeout Issues
      case 'request_timeout':
        return RegisterErrorType.networkRequestFailed;
        
      default:
        // Any other error code
        return RegisterErrorType.unknown;
    }
  }

  String getMessage() {
    return message;
  }
}