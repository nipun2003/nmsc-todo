


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppColor {
  // Original Android Colors (converted from 0xFF... to 0xFF...)
  // The '0x' prefix and the 'FF' alpha channel are standard for fully opaque colors.

  // --- Material Design 3 Palette Examples (Likely from Compose) ---
  static const Color purple80 = Color(0xFFD0BCFF);
  static const Color purpleGrey80 = Color(0xFFCCC2DC);
  static const Color pink80 = Color(0xFFEFB8C8);

  static const Color purple40 = Color(0xFF6650a4);
  static const Color purpleGrey40 = Color(0xFF625b71);
  static const Color pink40 = Color(0xFF7D5260);

  // --- Theme/App Specific Colors ---
  static const Color colorBackground = Color(0xFFFFFFFF); // White
  static const Color colorForeground = Color(0xFF222225); // Dark Gray/Near Black

  // --- Primary Colors ---
  static const Color colorPrimary = Color(0xFF804DFF);
  static const Color colorPrimary100 = Color(0xFFECE8FF);
  static const Color colorPrimary400 = Color(0xFFA285FF);
  static const Color colorPrimaryForeground = Color(0xFFFFFFFF);
  static const Color colorPrimaryContainer = Color(0xFFECE8FF);

  // --- Secondary Colors ---
  static const Color colorSecondary = Color(0xFFF6F5F9); // Very light gray
  static const Color colorSecondaryForeground = Color(0xFF777679); // Medium gray
  static const Color secondary = Color(0xFFFA3ABF); // Pink/Magenta (Same as Tertiary)

  // --- Tertiary Colors ---
  static const Color colorTertiary = Color(0xFFFA3ABF); // Pink/Magenta
  static const Color colorTertiaryContainer = Color(0xFFFEE5F8);

  // --- Status and Utility Colors ---
  static const Color successColor = Color(0xFF34C759); // Green
  static const Color error = Color(0xFFFF3B30); // Bright Red
  static const Color error50 = Color(0xFFFFEBEE);
  static const Color error100 = Color(0xFFFFCDD2);
  static const Color neutral = Color(0xFFA09FA3); // Neutral gray
  static const Color background = Color(0xFFFFFFFF); // White (Duplicate of colorBackground)
  static const Color foreground = Color(0xFF222225); // Dark Gray (Duplicate of colorForeground)
  static const Color transparent = Color(0x00000000); // Fully Transparent

  // --- Surface and Content Colors ---
  static const Color surfaceSecondary = Color(0xFFF6F5F9); // Light gray (Duplicate of colorSecondary)
  static const Color surfaceDisabled = Color(0xFFEFEEF2);
  static const Color contentDisabled = Color(0xFFBFBEC2);
  static const Color contentSecondary = Color(0xFF777679); // Medium gray (Duplicate of colorSecondaryForeground)
  static const Color borderColor = Color(0xFF777679); // Medium gray (Duplicate of contentSecondary)
  static const Color defaultBorder = Color(0xFFD1D1D1);
  static const Color bottomNavTextColor = Color(0xFF0B0026); // Very dark purple/blue

  // --- Grays ---
  static const Color colorGrey800 = Color(0xFF444346); // Darker gray

  // --- Existing MaterialColor (as a reference/example in your prompt) ---
  // Note: This block is kept as-is from your prompt for completeness,
  // but it doesn't directly use the colors you provided above.
  static const int _primaryColorValue = 0xFF9E77ED;

  static const MaterialColor primaryColor = MaterialColor(_primaryColorValue, <int, Color>{
    50: Color(0xFFFCFAFF),
    100: Color(0xFFF9F5FF),
    200: Color(0xFFE9D7FE),
    300: Color(0xFFD6BBFB),
    400: Color(0xFFB692F6),
    500: Color(_primaryColorValue),
    600: Color(0xFF7F56D9),
    700: Color(0xFF6941C6),
    800: Color(0xFF53389E),
    900: Color(0xFF42307D),
  });

}

// --- 4.1. Light Color Scheme (Matching LightColorScheme) ---
final lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Background/Surface
  surface: AppColor.colorBackground,
  onSurface: AppColor.colorForeground,

  // Primary
  primary: AppColor.colorPrimary,
  onPrimary: AppColor.colorPrimaryForeground,
  primaryContainer: AppColor.colorPrimaryContainer,
  onPrimaryContainer: AppColor.colorPrimary,

  // Secondary
  secondary: AppColor.colorSecondary,
  onSecondary: AppColor.colorSecondaryForeground,
  secondaryContainer: AppColor.colorSecondary,
  onSecondaryContainer: AppColor.colorSecondaryForeground,

  // Tertiary
  tertiary: AppColor.colorTertiary,
  onTertiary: AppColor.colorBackground,
  tertiaryContainer: AppColor.colorTertiaryContainer,
  onTertiaryContainer: AppColor.colorTertiary,

  // Error
  error: AppColor.error,
  onError: AppColor.colorBackground,
  errorContainer: AppColor.error50,
  onErrorContainer: AppColor.error,

  // Additional M3/Compose variants mapped to Flutter
  surfaceContainerHighest: AppColor.colorPrimaryContainer,
  onSurfaceVariant: AppColor.contentDisabled,
  outline: AppColor.defaultBorder,
  scrim: AppColor.neutral,
  // Flutter doesn't have a direct 'surfaceDim' equivalent, but these cover the theme context.
);