import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color colorPrimary =
      Color(0xFF7B4E38);

  static const Color colorPrimaryContainer =
      Color(0xFFD8B08C);

  static const Color colorOnPrimaryContainer =
      Color(0xFF4A2C1D);

  static const Color colorPrimaryFixed =
      Color(0xFF5C3A29);

  static const Color colorSurface =
      Color(0xFFFFFBF9);

  static const Color colorOnSurface =
      Color(0xFF1F1F1F);

  static const Color colorOnSurfaceVariant =
      Color(0xFF7A7A7A);

  static const Color colorInverseSurface =
      Color(0xFF3A261C);

  static const Color colorOutlineVariant =
      Color(0xFFE7D8D2);

  static const Color colorOnPrimary =
      Colors.white;

  static const LinearGradient primaryGradient =
      LinearGradient(
    colors: [
      colorPrimary,
      colorPrimaryFixed,
    ],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme =
      ThemeData(

    useMaterial3: true,

    scaffoldBackgroundColor:
        colorSurface,

    colorScheme:
        const ColorScheme.light(

      primary: colorPrimary,

      onPrimary: colorOnPrimary,

      primaryContainer:
          colorPrimaryContainer,

      onPrimaryContainer:
          colorOnPrimaryContainer,

      surface: colorSurface,

      onSurface: colorOnSurface,

      error: Colors.red,

      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: colorSurface,

      foregroundColor:
          colorOnSurface,

      elevation: 0,

      centerTitle: true,

      iconTheme: IconThemeData(
        color: colorOnSurface,
      ),
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(

      backgroundColor:
          colorPrimary,

      foregroundColor:
          Colors.white,
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(
        backgroundColor:
            colorPrimary,

        foregroundColor:
            Colors.white,

        elevation: 0,

        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),
      ),
    ),

    inputDecorationTheme:
        InputDecorationTheme(

      filled: true,

      fillColor:
          const Color(0xFFFFE9E5)
              .withOpacity(0.5),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: const BorderSide(
          color: colorOutlineVariant,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: const BorderSide(
          color: colorPrimary,
          width: 2,
        ),
      ),
    ),

    textTheme:
        Typography.material2021().black,
  );
}