import 'package:flutter/material.dart';
import '../foundation/spacing.dart';

class AppButtonTheme {
  static FilledButtonThemeData filled(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusMedium,
        ),
        foregroundColor: isDark ? Colors.black : colors.onPrimary,
        backgroundColor: isDark ? Colors.white : colors.primary,
        elevation: isDark ? 0 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  static OutlinedButtonThemeData outlined(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusMedium,
        ),
        foregroundColor: isDark ? Colors.white : colors.primary,
        side: BorderSide(
          color: isDark ? Colors.white : colors.outline,
          width: isDark ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  static TextButtonThemeData text(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusMedium,
        ),
        foregroundColor: isDark ? Colors.white : colors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
