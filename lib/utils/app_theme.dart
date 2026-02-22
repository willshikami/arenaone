import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF6A1A);
  static const Color secondaryOrange = Color(0xFFFF7A2F);
  static const Color accentOrange = Color(0xFFFF5C00);
  static const Color darkBackground = Color(0xFF0D0D10);
  static const Color darkSurface = Color(0xFF16161C);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        onPrimary: Colors.white,
        primary: primaryOrange,
        secondary: secondaryOrange,
        surface: darkSurface,
        onSurface: Colors.white,
        surfaceContainerHighest: Color(0xFF1F1F26),
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: GoogleFonts.instrumentSansTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkBackground,
        selectedItemColor: primaryOrange,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: primaryOrange,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0D0D10), // A dark base for the app's professional feel
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.instrumentSansTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
    );
  }
}
