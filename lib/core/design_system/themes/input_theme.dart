import 'package:flutter/material.dart';
import 'package:pickture/core/design_system/foundation/colors.dart';
import '../foundation/spacing.dart';

class AppInputTheme {
  static InputDecorationTheme theme(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    return InputDecorationTheme(
      contentPadding: AppSpacing.paddingAll,
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : colors.surface,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey : Colors.grey.shade600,
      ),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.radiusMedium,
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : colors.outline,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.radiusMedium,
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : colors.outline,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.radiusMedium,
        borderSide: BorderSide(
          color: colors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.radiusMedium,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.radiusMedium,
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      prefixIconColor: isDark ? Colors.grey : colors.outline,
      suffixIconColor: isDark ? Colors.grey : colors.outline,
    );
  }
}
