import 'package:flutter/material.dart';


// Note: Flutter's default Material 3 TextTheme uses 14 styles (display, headline,
// title, body, label, each in large, medium, small). The Compose snippet only
// defined headline, title, body, and label. Display styles are left as default
// or can be added if needed, but for a direct conversion, we focus on the defined ones.

const appTypography = TextTheme(
  // The 'display' styles from your target are kept but will be overridden
  // by any subsequent 'headline', 'title', 'body', or 'label' styles
  // if they share the same properties and are part of the base theme.
  // For this conversion, we will focus on matching the defined styles.

  // --- HEADLINE ---
  headlineLarge: TextStyle(
    // fontSize = 34.sp
    fontSize: 34.0,
    // fontWeight = FontWeight.ExtraBold -> FontWeight.w800
    fontWeight: FontWeight.w800,
    // lineHeight = 40.sp -> height: 40.0 / 34.0
    height: 40.0 / 34.0,
    // letterSpacing = 0.25.sp
    letterSpacing: 0.25,
  ),
  headlineMedium: TextStyle(
    // fontSize = 20.sp
    fontSize: 20.0,
    // fontWeight = FontWeight.Bold -> FontWeight.w700
    fontWeight: FontWeight.w700,
    // lineHeight is omitted (uses default)
    // letterSpacing = 0.15.sp
    letterSpacing: 0.15,
  ),
  headlineSmall: TextStyle(
    // fontSize = 16.sp
    fontSize: 16.0,
    // fontWeight = FontWeight.Bold -> FontWeight.w700
    fontWeight: FontWeight.w700,
    // lineHeight is omitted (uses default)
    // letterSpacing is omitted (uses default)
  ),

  // --- TITLE ---
  titleLarge: TextStyle(
    // fontSize = 24.sp
    fontSize: 24.0,
    // fontWeight = FontWeight.Bold -> FontWeight.w700
    fontWeight: FontWeight.w700,
    // lineHeight = 28.sp -> height: 28.0 / 24.0
    height: 28.0 / 24.0,
    // letterSpacing = 0.15.sp
    letterSpacing: 0.15,
  ),
  titleMedium: TextStyle(
    // fontSize = 20.sp
    fontSize: 20.0,
    // fontWeight = FontWeight.SemiBold -> FontWeight.w600
    fontWeight: FontWeight.w600,
    // lineHeight = 24.sp -> height: 24.0 / 20.0
    height: 24.0 / 20.0,
    // letterSpacing = 0.15.sp
    letterSpacing: 0.15,
  ),
  titleSmall: TextStyle(
    // fontSize = 16.sp
    fontSize: 16.0,
    // fontWeight = FontWeight.SemiBold -> FontWeight.w600
    fontWeight: FontWeight.w600,
    // lineHeight = 20.sp -> height: 20.0 / 16.0
    height: 20.0 / 16.0,
    // letterSpacing = 0.15.sp
    letterSpacing: 0.15,
  ),

  // --- BODY ---
  bodyLarge: TextStyle(
    // fontSize = 16.sp
    fontSize: 16.0,
    // fontWeight = FontWeight.Normal -> FontWeight.w400
    fontWeight: FontWeight.w400,
    // lineHeight = 24.sp -> height: 24.0 / 16.0
    height: 24.0 / 16.0,
    // letterSpacing = 0.5.sp
    letterSpacing: 0.5,
  ),
  bodyMedium: TextStyle(
    // fontSize = 14.sp
    fontSize: 14.0,
    // fontWeight = FontWeight.Normal -> FontWeight.w400
    fontWeight: FontWeight.w400,
    // lineHeight = 20.sp -> height: 20.0 / 14.0
    height: 20.0 / 14.0,
    // letterSpacing = 0.25.sp
    letterSpacing: 0.25,
  ),
  bodySmall: TextStyle(
    // fontSize = 12.sp
    fontSize: 12.0,
    // fontWeight = FontWeight.Normal -> FontWeight.w400
    fontWeight: FontWeight.w400,
    // lineHeight = 16.sp -> height: 16.0 / 12.0
    height: 16.0 / 12.0,
    // letterSpacing = 0.4.sp
    letterSpacing: 0.4,
  ),

  // --- LABEL ---
  labelLarge: TextStyle(
    // fontSize = 18.sp
    fontSize: 18.0,
    // fontWeight = FontWeight.Medium -> FontWeight.w500
    fontWeight: FontWeight.w500,
    // lineHeight = 20.sp -> height: 20.0 / 18.0
    height: 20.0 / 18.0,
    // letterSpacing = 0.1.sp
    letterSpacing: 0.1,
  ),
  labelMedium: TextStyle(
    // fontSize = 16.sp
    fontSize: 16.0,
    // fontWeight = FontWeight.Medium -> FontWeight.w500
    fontWeight: FontWeight.w500,
    // lineHeight = 16.sp -> height: 16.0 / 16.0 = 1.0
    height: 1.0,
    // letterSpacing = 0.1.sp
    letterSpacing: 0.1,
  ),
  labelSmall: TextStyle(
    // fontSize = 14.sp
    fontSize: 14.0,
    // fontWeight = FontWeight.Medium -> FontWeight.w500
    fontWeight: FontWeight.w500,
    // lineHeight = 16.sp -> height: 16.0 / 14.0
    height: 16.0 / 14.0,
    // letterSpacing = 0.5.sp
    letterSpacing: 0.5,
  ),
);
