import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color bgDark = Color(0xFF0A0B10);
  static const Color panelBg = Color(0x66141623); // rgba(20, 22, 35, 0.4)
  static const Color borderGlass = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)

  static const Color primary = Color(0xFF00D2FF);
  static const Color primaryDark = Color(0xFF3A7BD5);
  static const Color purple = Color(0xFFA855F7);
  
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static const Color textMain = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: purple,
        background: bgDark,
        surface: panelBg,
        error: danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textMain,
        onSurface: textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textMain),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(Colors.transparent),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w600, color: textMuted, fontSize: 12),
        dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.08);
          }
          return Colors.transparent;
        }),
      ),
    );
  }
}
