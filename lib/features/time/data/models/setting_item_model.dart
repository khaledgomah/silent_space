import 'package:flutter/material.dart';

class SettingItemModel {
  final String title;
  final Icon icon;
  final VoidCallback onTap;
  SettingItemModel({required this.title, required this.icon,required this.onTap});
}
