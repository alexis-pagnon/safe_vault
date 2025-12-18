
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {

  late final SharedPreferencesWithCache _prefs;

  SharedPreferencesRepository(this._prefs);

  bool get firstTime => _prefs.getBool('first_time') ?? true;
  String? get hashedPassword => _prefs.getString('hashed_password');
  String get theme => _prefs.getString('theme') ?? 'light';


  /// Update first time flag
  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool('first_time', value);
  }


  /// Update hashed password
  Future<void> setHashedPassword(String value) async {
    await _prefs.setString('hashed_password', value);
  }


  /// Update theme (light/dark)
  Future<void> setTheme(String value) async {
    await _prefs.setString('theme', value);
  }
}
