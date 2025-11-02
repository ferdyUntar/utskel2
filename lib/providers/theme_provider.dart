// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // update mira: menambah state untuk menyimpan ThemeMode (light / dark)
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  // update mira: toggle antara light dan dark, lalu notify agar UI berubah
  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // update mira: optional fungsionalitas untuk set explicit mode
  void setThemeMode(ThemeMode m) {
    _mode = m;
    notifyListeners();
  }
}
