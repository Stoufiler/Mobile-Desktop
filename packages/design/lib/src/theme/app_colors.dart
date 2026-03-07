import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  Color get primary => const Color(0xFF00A4DC);
  Color get primaryVariant => const Color(0xFF0086B3);
  Color get secondary => const Color(0xFFAA5CC3);

  Color get background => const Color(0xFF101010);
  Color get surface => const Color(0xFF1A1A1A);
  Color get surfaceVariant => const Color(0xFF252525);
  Color get card => const Color(0xFF202020);

  Color get onPrimary => Colors.white;
  Color get onBackground => Colors.white;
  Color get onSurface => Colors.white;
  Color get onSurfaceVariant => const Color(0xFFB3B3B3);
  Color get textSecondary => const Color(0xFF999999);

  Color get error => const Color(0xFFCF6679);
  Color get success => const Color(0xFF4CAF50);
  Color get warning => const Color(0xFFFFC107);
}
