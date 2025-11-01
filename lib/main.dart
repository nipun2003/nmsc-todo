import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nmsc_todo/core/ui/app_router.dart';
import 'package:nmsc_todo/core/ui/theme.dart';
import 'package:nmsc_todo/di/app_module.dart';
import 'package:nmsc_todo/presentation/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final sUrl = dotenv.env["SUPABASE_URL"] ?? "";
  final sKey = dotenv.env["SUPABASE_KEY"] ?? "";
  await Supabase.initialize(url: sUrl, anonKey: sKey);
  setupLocator();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthNotifier())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(context);
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData,
      routerConfig: router,
    );
  }
}
