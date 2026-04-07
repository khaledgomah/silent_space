import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Legacy Brand Colors (Consider Deprecating) ──
  static const Color primaryLight = Color(0xFF5C6BC0);
  static const Color primaryDark = Color(0xFF9FA8DA);
  static const Color seedColor = Color(0xFF5C6BC0);

  // ── Constants Colors ──
  static const Color primaryColor = Color(0xFF1A1A1A);
  static final Color secondaryColor = Colors.grey.withValues(alpha: .2);

  // ── Navigation Bar Colors (Figma) ──
  static const Color navBarActive = Color(0xFF00AA5B);
  static const Color navBarInactiveLabel = Color(0xFF5E5F60);
  static const Color navBarIndicator = Color(0xFF00AA5B);

  // ── Specific Colors Used in App ──
  static const Color chartPurple = Color(0xFF8043F9);
  static const Color textFormBorder = Color.fromARGB(255, 155, 165, 244);

  // ── General Standard Colors ──
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  // ── Logify Design Colors (Figma Node 25-348) ──
  static const Color logifyBackground = Color(0xFF0B0B1E); // Dark navy bg
  static const Color logifyPrimary = Color(0xFFBF007E); // Magenta / Pink accent
  static const Color logifyNavy = Color(0xFF030C43); // Deep Navy for side panel
  static const Color logifyGrey = Color(0xFF8E8E8E); // Placeholder text grey
  static const Color logifyLightGrey = Color(0xFF3A3A5C); // Underline on dark bg
  static const Color logifyWhite = Color(0xFFFFFFFF);
  static const Color logifyDark = Color(0xFF000000);
  static const Color logifyGoogleRed = Color(0xFFDB4437);

  static final Color grey800 = Colors.grey.shade800;
  static final Color greyWithAlpha20 = Colors.grey.withValues(alpha: 0.2);
}
