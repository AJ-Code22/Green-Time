import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Mode Colors - Eco-Sustainability Theme
  static const Color _lightPrimary = Color(0xFF5ADCDE);
  static const Color _lightSecondary = Color(0xFF82E5E8);
  static const Color _lightTertiary = Color(0xFFAAEFF0);
  static const Color _lightBackground = Color(0xFFEAFCFC);
  static const Color _lightSurface = Color(0xFFCDF8F7);

  // Dark Mode Colors
  static const Color _darkPrimary = Color(0xFF5ADCDE);
  static const Color _darkSecondary = Color(0xFF224942);
  static const Color _darkTertiary = Color(0xFF245B47);
  static const Color _darkBackground = Color(0xFF0D3A32);
  static const Color _darkSurface = Color(0xFF192A3C);

  // Additional Colors
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _warningOrange = Color(0xFFFFA726);
  static const Color _errorRed = Color(0xFFEF5350);
  static const Color _infoBlue = Color(0xFF29B6F6);

  /// Light Theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        background: _lightBackground,
        surface: _lightSurface,
        error: _errorRed,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimary,
          side: const BorderSide(color: _lightPrimary, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightTertiary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightTertiary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.white),
        backgroundColor: _successGreen,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black,
            ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightTertiary.withOpacity(0.5),
        selectedColor: _lightPrimary,
        labelStyle: GoogleFonts.poppins(color: Colors.black87),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Dark Theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _darkTertiary,
        background: _darkBackground,
        surface: _darkSurface,
        error: _errorRed,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _darkSurface,
        foregroundColor: _darkPrimary,
        iconTheme: const IconThemeData(color: _darkPrimary),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkBackground,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: const BorderSide(color: _darkPrimary, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1a1a1a),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkTertiary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkTertiary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.white),
        backgroundColor: _successGreen,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.apply(
              bodyColor: Colors.grey[100],
              displayColor: Colors.white,
            ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkBackground,
        elevation: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkTertiary.withOpacity(0.3),
        selectedColor: _darkPrimary,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[100]),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Color helpers for specific use cases
  static Color getSuccessColor(BuildContext context) => _successGreen;
  static Color getWarningColor(BuildContext context) => _warningOrange;
  static Color getErrorColor(BuildContext context) => _errorRed;
  static Color getInfoColor(BuildContext context) => _infoBlue;
}
