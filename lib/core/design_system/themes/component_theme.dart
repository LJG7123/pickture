import 'package:flutter/material.dart';
import '../foundation/spacing.dart';

class AppComponentTheme {
  static CardTheme card(ColorScheme colors) {
    return CardTheme(
      color: colors.surfaceContainerHighest,
      elevation: 2,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusMedium,
      ),
    );
  }

  static IconThemeData icon(ColorScheme colors) {
    return IconThemeData(
      color: colors.onSurface,
      size: AppSpacing.iconMd,
    );
  }

  static DividerThemeData divider(ColorScheme colors) {
    return DividerThemeData(
      color: colors.outline.withAlpha(51),
      space: AppSpacing.dividerHeight,
      indent: AppSpacing.dividerIndent,
      endIndent: AppSpacing.dividerIndent,
    );
  }
}
