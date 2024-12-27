import 'package:flutter/material.dart';
import '../foundation/spacing.dart';
import '../foundation/typography.dart';

class AppNavigationTheme {
  static NavigationDrawerThemeData drawer(ColorScheme colors) {
    return NavigationDrawerThemeData(
      backgroundColor: colors.surface,
      elevation: 0,
      tileHeight: AppSpacing.buttonHeight,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusMedium,
      ),
    );
  }

  static NavigationBarThemeData bar(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    return NavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: colors.shadow,
      height: 65,
      indicatorColor: colors.secondaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.onSecondaryContainer);
        }
        return IconThemeData(color: colors.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelMedium.copyWith(color: colors.onSurface);
        }
        return AppTypography.labelMedium.copyWith(color: colors.onSurfaceVariant);
      }),
    );
  }

  static AppBarTheme appBar(ColorScheme colors) {
    return AppBarTheme(
      centerTitle: false,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      foregroundColor: colors.onSurface,
      iconTheme: IconThemeData(color: colors.onSurface),
      titleTextStyle: AppTypography.titleLarge.copyWith(color: colors.onSurface),
    );
  }
}
