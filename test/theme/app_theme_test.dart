import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/theme/app_theme.dart';
import 'package:flutter_boilerplate/theme/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme uses Material 3 and light brightness', () {
    final theme = AppTheme.light;
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
  });

  test('dark theme uses Material 3 and dark brightness', () {
    final theme = AppTheme.dark;
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.dark);
  });

  test('both themes seed their color scheme from AppColors.seed', () {
    final expected = ColorScheme.fromSeed(seedColor: AppColors.seed);
    expect(AppTheme.light.colorScheme.primary, expected.primary);
  });

  test('card and input shapes are built from AppRadii', () {
    final shape = AppTheme.light.cardTheme.shape;
    expect(
      shape,
      isA<RoundedRectangleBorder>().having(
        (border) => border.borderRadius,
        'borderRadius',
        BorderRadius.circular(AppRadii.md),
      ),
    );
  });
}
