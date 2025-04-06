import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(String mode) {
    _themeMode = mode == "On" ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
