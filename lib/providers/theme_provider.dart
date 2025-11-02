// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // update mira: menyimpan status dark mode (true = dark)
  bool _isDarkMode = false; // update mira

  // update mira: getter boolean untuk mudah dipakai di UI
  bool get isDarkMode => _isDarkMode; // update mira

  // update mira: getter ThemeMode yang dipakai MaterialApp
  ThemeMode get currentTheme =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light; // update mira

  // update mira: toggle antara light dan dark
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // update mira: set explicit mode (opsional)
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}