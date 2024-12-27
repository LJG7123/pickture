import 'package:flutter/material.dart';
import '../foundation/colors.dart';

class AppColorScheme {
  static const light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceContainerHighest: Color(0xFFF4F4F4),
    onSurfaceVariant: Colors.black87,
    outline: AppColors.outline,
  );

  static const dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF2C2C2C),
    onPrimaryContainer: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF404040),
    onSecondaryContainer: Colors.white,
    error: Color(0xFFCF6679),
    onError: Colors.black,
    errorContainer: Color(0xFF1E1E1E),
    onErrorContainer: Color(0xFFCF6679),
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF2C2C2C),
    onSurfaceVariant: Colors.grey,
    outline: Colors.grey,
  );
}
