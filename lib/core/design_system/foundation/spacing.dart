import 'package:flutter/material.dart';

class AppSpacing {
  // Insets (여백)
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;

  // Sizes (크기)
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // Component Sizes
  static const double buttonHeight = 48;
  static const double inputHeight = 56;
  static const double cardRadius = 16;
  static const double avatarSizeSmall = 32;
  static const double avatarSizeMedium = 40;
  static const double avatarSizeLarge = 56;

  // Layout
  static const double maxWidth = 1200;
  static const double drawerWidth = 300;

  // Edge Insets
  static const EdgeInsets paddingAll = EdgeInsets.all(md);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: md);

  static const EdgeInsets paddingSmall = EdgeInsets.all(sm);
  static const EdgeInsets paddingLarge = EdgeInsets.all(lg);

  // Border Radius
  static final BorderRadius radiusSmall = BorderRadius.circular(sm);
  static final BorderRadius radiusMedium = BorderRadius.circular(md);
  static final BorderRadius radiusLarge = BorderRadius.circular(lg);

  // Divider
  static const double dividerHeight = 1;
  static const double dividerIndent = md;
}
