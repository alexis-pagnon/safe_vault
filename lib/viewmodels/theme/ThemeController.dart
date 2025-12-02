import 'package:flutter/material.dart';
import 'AppThemes.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _theme = AppThemes.light;

  ThemeData get theme => _theme;

  bool get isDark => _theme.brightness == Brightness.dark;

  void toggleTheme() {
    _theme = isDark ? AppThemes.light : AppThemes.dark;
    notifyListeners();
  }
}
