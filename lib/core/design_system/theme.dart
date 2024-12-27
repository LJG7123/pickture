import 'package:flutter/material.dart';
import 'foundation/typography.dart';
import 'themes/button_theme.dart';
import 'themes/color_schemes.dart';
import 'themes/component_theme.dart';
import 'themes/input_theme.dart';
import 'themes/navigation_theme.dart';

class AppTheme {
  static ThemeData light() {
    return _buildTheme(AppColorScheme.light);
  }

  static ThemeData dark() {
    return _buildTheme(AppColorScheme.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      filledButtonTheme: AppButtonTheme.filled(colorScheme),
      outlinedButtonTheme: AppButtonTheme.outlined(colorScheme),
      textButtonTheme: AppButtonTheme.text(colorScheme),
      inputDecorationTheme: AppInputTheme.theme(colorScheme),
      navigationDrawerTheme: AppNavigationTheme.drawer(colorScheme),
      navigationBarTheme: AppNavigationTheme.bar(colorScheme),
      appBarTheme: AppNavigationTheme.appBar(colorScheme),
      cardTheme: AppComponentTheme.card(colorScheme),
      iconTheme: AppComponentTheme.icon(colorScheme),
      dividerTheme: AppComponentTheme.divider(colorScheme),
    );
  }
}
