
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  final Future<SharedPreferencesWithCache> _prefs =
  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: <String>{'hashed_password', 'theme' }));

  /// Get the hash of the master password
  Future<String> getHashedPassword() async {
    final SharedPreferencesWithCache prefs = await _prefs;
    return prefs.getString('hashed_password') ?? '';
  }

  /// Set the hash of the master password
  Future<void> setHashedPassword(String hashedPassword) async {
    final SharedPreferencesWithCache prefs = await _prefs;
    await prefs.setString('hashed_password', hashedPassword);
    notifyListeners();
  }

  /// Get the selected theme (light or dark)
  Future<String> getTheme() async {
    final SharedPreferencesWithCache prefs = await _prefs;
    return prefs.getString('theme') ?? 'light';
  }

  /// Set the selected theme (light or dark)
  Future<void> setTheme(String theme) async {
    final SharedPreferencesWithCache prefs = await _prefs;
    await prefs.setString('theme', theme);
    notifyListeners();
  }

}