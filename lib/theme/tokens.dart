import 'package:flutter/material.dart';

/// Seed colors used to build [ThemeData]. Views must read colors from
/// `Theme.of(context).colorScheme`, never from this class — the theme is the
/// single source of truth for color.
abstract final class AppColors {
  static const Color seed = Color(0xFF2E5AAC);
}

/// Spacing scale in logical pixels. Flutter has no theme channel for spacing,
/// so views read these directly.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Corner radius scale. Consumed both by [AppTheme] for component shapes and
/// directly by views that draw their own containers.
abstract final class AppRadii {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
}

/// Base text styles used to build the theme's `TextTheme`. Views must read
/// text styles from `Theme.of(context).textTheme`, never from this class.
abstract final class AppTypography {
  static const String fontFamily = 'Roboto';

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
