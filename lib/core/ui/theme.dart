

import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/colors.dart';
import 'package:nmsc_todo/core/ui/shapes.dart';
import 'package:nmsc_todo/core/ui/type.dart' show appTypography;

class AppTheme {
  // Define the base shape for widgets that support it (e.g., Card, Dialog, etc.)
  static final _defaultShape = RoundedRectangleBorder(
    borderRadius: AppShapes.medium,
  );

  static final ThemeData lightThemeData = ThemeData(
    // Set global font family
    fontFamily: "Nunito",
    // Set custom color scheme
    colorScheme: lightColorScheme,
    // Set custom typography
    textTheme: appTypography,
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: AppShapes.medium
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: AppShapes.small, // Using small for snackbars
      ),
    ),
    // Use the circle shape for Floating Action Button (extraLarge = CircleShape)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
    useMaterial3: true,
  );
}
