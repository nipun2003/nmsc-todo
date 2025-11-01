import 'package:get_it/get_it.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/data/repository/auth_repository_impl.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/use_cases/login_use_case.dart';
import 'package:nmsc_todo/domain/use_cases/register_use_case.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/events/register_events.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<SupabaseAuthService>(supabaseAuthService);

  locator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authService: locator<SupabaseAuthService>()),
  );

  locator.registerSingleton<LoginEventBus>(LoginEventBus());
  locator.registerSingleton<RegisterEventBus>(RegisterEventBus());
  locator.registerSingleton<RegisterUseCase>(RegisterUseCase());

  locator.registerSingleton<LoginUseCase>(
    LoginUseCase(authRepository: locator<AuthRepository>()),
  );
  // Register your services and repositories here
}
