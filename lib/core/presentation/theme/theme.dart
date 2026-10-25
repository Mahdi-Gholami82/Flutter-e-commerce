import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const royalBlue = Color(0xFF23529E);
  static const amber = Color(0xFFE9A23B);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: royalBlue,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDCE7F7),
    onPrimaryContainer: Color(0xFF102F60),
    secondary: Color(0xFF526A8C),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFDCE4F0),
    onSecondaryContainer: Color(0xFF192D49),
    tertiary: amber,
    onTertiary: Color(0xFF18181B),
    tertiaryContainer: Color(0xFFFCE8C8),
    onTertiaryContainer: Color(0xFF492C08),
    error: Color(0xFFDC2626),
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Colors.white,
    onSurface: Color(0xFF18181B),
    onSurfaceVariant: Color(0xFF52525B),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFAFAFA),
    surfaceContainer: Color(0xFFF4F4F5),
    surfaceContainerHigh: Color(0xFFE4E4E7),
    surfaceContainerHighest: Color(0xFFD4D4D8),
    outline: Color(0xFF71717A),
    outlineVariant: Color(0xFFD4D4D8),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF27272A),
    onInverseSurface: Color(0xFFFAFAFA),
    inversePrimary: Color(0xFF9BBDF5),
    surfaceTint: royalBlue,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8FB5F5),
    onPrimary: Color(0xFF102F60),
    primaryContainer: Color(0xFF234B85),
    onPrimaryContainer: Color(0xFFDCE7F7),
    secondary: Color(0xFFB2C5E2),
    onSecondary: Color(0xFF233753),
    secondaryContainer: Color(0xFF394D69),
    onSecondaryContainer: Color(0xFFDCE4F0),
    tertiary: amber,
    onTertiary: Color(0xFF18181B),
    tertiaryContainer: Color(0xFF704710),
    onTertiaryContainer: Color(0xFFFFE5B8),
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF450A0A),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Color(0xFF18181B),
    onSurface: Color(0xFFFAFAFA),
    onSurfaceVariant: Color(0xFFD4D4D8),
    surfaceContainerLowest: Color(0xFF09090B),
    surfaceContainerLow: Color(0xFF141416),
    surfaceContainer: Color(0xFF202023),
    surfaceContainerHigh: Color(0xFF27272A),
    surfaceContainerHighest: Color(0xFF3F3F46),
    outline: Color(0xFF71717A),
    outlineVariant: Color(0xFF3F3F46),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF4F4F5),
    onInverseSurface: Color(0xFF18181B),
    inversePrimary: royalBlue,
    surfaceTint: Color(0xFF8FB5F5),
  );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }

  static ThemeData get light {
    // does not anything in release mode
    _validateTextStylesExist(_light.textTheme);
    return _light;
  }

  static final ThemeData _light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: const Color(0xFFF8F9FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F9FC),
      foregroundColor: Color(0xFF18181B),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD4D4D8)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFD4D4D8),
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: _inputDecorationTheme(lightColorScheme),
  );

  static ThemeData get dark {
    // does not anything in release mode
    _validateTextStylesExist(_dark.textTheme);
    return _dark;
  }

  static final ThemeData _dark = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: const Color(0xFF141519),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF141519),
      foregroundColor: Color(0xFFFAFAFA),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF18181B),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF3F3F46)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3F3F46),
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: _inputDecorationTheme(darkColorScheme),
  );

  static void _validateTextStylesExist(TextTheme textTheme) {
    assert(
      [
        textTheme.displayLarge,
        textTheme.displayMedium,
        textTheme.displaySmall,
        textTheme.headlineLarge,
        textTheme.headlineMedium,
        textTheme.headlineSmall,
        textTheme.titleLarge,
        textTheme.titleMedium,
        textTheme.titleSmall,
        textTheme.bodyLarge,
        textTheme.bodyMedium,
        textTheme.bodySmall,
        textTheme.labelLarge,
        textTheme.labelMedium,
        textTheme.labelSmall,
      ].every((style) => style != null),
    );
  }
}
