import 'package:flutter/material.dart';

class AppTypography {
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font Sizes
  static const double xs = 12;
  static const double sm = 14;
  static const double base = 16;
  static const double lg = 18;
  static const double xl = 20;
  static const double xxl = 24;
  static const double display = 32;

  // Line Heights
  static const double tight = 1.25;
  static const double normal = 1.5;
  static const double loose = 1.75;

  // Text Styles
  static TextStyle get displayLarge => const TextStyle(
        fontSize: display,
        fontWeight: bold,
        letterSpacing: -0.5,
        height: tight,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: xxl,
        fontWeight: bold,
        letterSpacing: -0.5,
        height: tight,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: xl,
        fontWeight: semiBold,
        letterSpacing: -0.5,
        height: tight,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: lg,
        fontWeight: semiBold,
        height: tight,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: base,
        fontWeight: regular,
        height: normal,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: sm,
        fontWeight: regular,
        height: normal,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: xs,
        fontWeight: regular,
        height: normal,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontSize: base,
        fontWeight: medium,
        height: normal,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: sm,
        fontWeight: medium,
        height: normal,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: xs,
        fontWeight: medium,
        height: normal,
      );
}
