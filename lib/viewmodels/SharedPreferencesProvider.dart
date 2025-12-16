
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  late final SharedPreferencesWithCache _prefs;

  String _hashedPassword = '';
  String _theme = 'light';
  bool _firstTime = true;
  bool _initialized = false; // Indicates if initialization is complete

  bool get firstTime => _firstTime;
  String get hashedPassword => _hashedPassword;
  String get theme => _theme;
  bool get initialized => _initialized;


  /// Initialize SharedPreferences and load values
  Future<void> init() async {
    // Load SharedPreferences with caching
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {'first_time', 'hashed_password', 'theme'},
      ),
    );

    _firstTime = _prefs.getBool('first_time') ?? true;
    _hashedPassword = _prefs.getString('hashed_password') ?? '';
    _theme = _prefs.getString('theme') ?? 'light';

    _initialized = true;
    notifyListeners();
  }


  /// Update first time flag
  Future<void> setFirstTime(bool value) async {
    _firstTime = value;
    await _prefs.setBool('first_time', value);
    notifyListeners();
  }


  /// Update hashed password
  Future<void> setHashedPassword(String value) async {
    _hashedPassword = value;
    await _prefs.setString('hashed_password', value);
    notifyListeners();
  }


  /// Update theme (light/dark)
  Future<void> setTheme(String value) async {
    _theme = value;
    await _prefs.setString('theme', value);
    notifyListeners();
  }
}
