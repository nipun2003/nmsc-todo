import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nmsc_todo/core/ui/theme.dart';
import 'package:nmsc_todo/presentation/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final sUrl = dotenv.env["SUPABASE_URL"] ?? "";
  final sKey = dotenv.env["SUPABASE_KEY"] ?? "";
  await Supabase.initialize(url: sUrl, anonKey: sKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData,
      home: const SplashScreen(),
    );
  }
}
