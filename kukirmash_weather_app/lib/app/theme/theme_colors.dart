import 'package:flutter/material.dart';

/// Цветовая палитра приложения.
abstract final class ThemeColors {
  /// Основной тёмно-синий цвет текста и акцентов.
  static const Color ink = Color(0xFF10233D);

  /// Второстепенный цвет текста.
  static const Color muted = Color(0xFF64748B);

  /// Фон приложения.
  static const Color canvas = Color(0xFFF3F6FB);

  /// Поверхность карточек.
  static const Color surface = Color(0xFFFFFFFF);

  /// Основной акцент.
  static const Color primary = Color(0xFF1B4B7A);

  /// Светлый акцент для градиентов и подсветок.
  static const Color primaryLight = Color(0xFF4B84C6);

  /// Тёплый акцент (солнце).
  static const Color warm = Color(0xFFF2B84B);

  /// Линии и разделители.
  static const Color line = Color(0xFFE2E9F2);

  /// Мягкая подложка для иконок.
  static const Color softBlue = Color(0xFFEAF2FC);

  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
