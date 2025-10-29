import 'package:flutter/material.dart';
import 'package:nmsc_music/core/ui/colors.dart';

void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
      ),
      home: Scaffold(
        body: const Center(
          child: Text("Hello World!"),
        ),
      ),
    );
  }
}
