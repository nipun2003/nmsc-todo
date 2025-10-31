import 'package:get_it/get_it.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/data/repository/auth_repository_impl.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/use_cases/login_use_case.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<SupabaseAuthService>(supabaseAuthService);

  locator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authService: locator<SupabaseAuthService>()),
  );

  locator.registerSingleton(
    LoginUseCase(authRepository: locator<AuthRepository>()),
  );
  // Register your services and repositories here
}
