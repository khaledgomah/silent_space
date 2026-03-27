import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Colors ──
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
  // ── Logify Design Colors (Node 24-173) ──
  static const Color logifyPrimary = Color(0xFF0027BD); // Royal Blue
  static const Color logifyNavy = Color(0xFF030C43); // Deep Navy for side panel
  static const Color logifyGrey = Color(0xFF757575); // Secondary text grey
  static const Color logifyLightGrey = Color(0xFFD1D1D1); // Underline color
  static const Color logifyWhite = Color(0xFFFFFFFF);
  static const Color logifyDark = Color(0xFF000000);
  static const Color logifyGoogleRed = Color(0xFFDB4437);
  static const Color logifyFacebookBlue = Color(0xFF4267B2);

  static final Color grey800 = Colors.grey.shade800;
  static final Color greyWithAlpha20 = Colors.grey.withValues(alpha: 0.2);
}
