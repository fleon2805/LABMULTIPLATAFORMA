import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  static bool get isDark => themeNotifier.value == ThemeMode.dark;

  static void toggleTheme(bool isDarkMode) {
    themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
