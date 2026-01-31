import 'package:flutter/material.dart';
import 'AppThemes.dart';

class ThemeController extends ChangeNotifier {
  late ThemeData _theme;
  bool _isDark = false;

  ThemeController({required String themeMode}) {
    _theme = themeMode == 'dark' ? AppThemes.dark : AppThemes.light;
    _isDark = themeMode == 'dark';
  }


  ThemeData get theme => _theme;

  bool get isDark => _isDark;

  /// Toggle theme between light and dark
  void toggleTheme() {
    _theme = isDark ? AppThemes.light : AppThemes.dark;
    _isDark = !isDark;
    notifyListeners();
  }
}