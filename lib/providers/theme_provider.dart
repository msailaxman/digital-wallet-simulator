import 'package:flutter/material.dart';

// ==============================================================================
// EXPERIMENT 5 & 6: STATE MANAGEMENT & THEMES
// Uses ChangeNotifier to update application theme dynamically across all screens.
// ==============================================================================

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Toggle between light and dark themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify all consumer widgets to rebuild
  }

  // Explicitly set theme mode
  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }
}
