import 'package:flutter/material.dart';

class SettingItemModel {
  SettingItemModel({required this.title, required this.icon, required this.onTap});
  final String title;
  final Icon icon;
  final VoidCallback onTap;
}
