import 'package:flutter/material.dart';

import 'theme_colors.dart';

/// Единая тема приложения.
class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: ThemeColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: ThemeColors.primary,
          secondary: ThemeColors.primaryLight,
          surface: ThemeColors.surface,
          onSurface: ThemeColors.ink,
          outline: ThemeColors.line,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ThemeColors.canvas,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 64,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: ThemeColors.canvas,
        surfaceTintColor: ThemeColors.transparent,
        foregroundColor: ThemeColors.ink,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: ThemeColors.ink,
        ),
      ),
      iconTheme: const IconThemeData(color: ThemeColors.ink, size: 22),
      dividerTheme: const DividerThemeData(
        color: ThemeColors.line,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ThemeColors.primary,
          foregroundColor: ThemeColors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeColors.primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ThemeColors.ink,
        contentTextStyle: TextStyle(color: ThemeColors.white),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 64,
        height: 1,
        fontWeight: FontWeight.w300,
        letterSpacing: -2.5,
        color: ThemeColors.ink,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 48,
        height: 1.05,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: ThemeColors.ink,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: ThemeColors.ink,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: ThemeColors.ink,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: ThemeColors.ink,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: ThemeColors.ink,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: ThemeColors.ink,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.55,
        color: ThemeColors.ink,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.45,
        color: ThemeColors.muted,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.4,
        color: ThemeColors.muted,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: ThemeColors.ink,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: ThemeColors.muted,
      ),
    );
  }
}
