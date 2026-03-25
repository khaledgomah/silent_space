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

  // ── Specific Colors Used in App ──
  static const Color chartPurple = Color(0xFF8043F9);
  static const Color textFormBorder = Color.fromARGB(255, 155, 165, 244);

  // ── General Standard Colors ──
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static final Color grey800 = Colors.grey.shade800;
  static final Color greyWithAlpha20 = Colors.grey.withValues(alpha: 0.2);
}
