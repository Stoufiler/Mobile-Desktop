import 'package:flutter/material.dart';
import 'package:jellyfin_design/jellyfin_design.dart';

/// App-wide theme configuration.
class AppTheme {
  const AppTheme._();

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: JellyfinTokens.colors.primary,
      secondary: JellyfinTokens.colors.secondary,
      surface: JellyfinTokens.colors.surface,
      error: JellyfinTokens.colors.error,
      onPrimary: JellyfinTokens.colors.onPrimary,
      onSurface: JellyfinTokens.colors.onSurface,
    ),
    scaffoldBackgroundColor: JellyfinTokens.colors.background,
    cardTheme: CardThemeData(
      color: JellyfinTokens.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JellyfinTokens.spacing.cardRadius),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: JellyfinTokens.colors.background,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: JellyfinTokens.colors.surface,
      selectedItemColor: JellyfinTokens.colors.primary,
      unselectedItemColor: JellyfinTokens.colors.textSecondary,
    ),
  );
}
