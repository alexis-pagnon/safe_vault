

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_vault/models/KeyGenerator.dart';

import 'DatabaseProvider.dart';
import 'SharedPreferencesProvider.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isReady = false;
  bool _isDbReady = false;
  bool _isSpReady = true; // TODO : initialize to false when SP init added
  bool _isAuthenticated = false;
  DatabaseProvider _databaseProvider;
  SharedPreferencesProvider? _sharedPreferencesProvider; // TODO : make it non-nullable when SP init added

  bool get isReady => _isReady;
  bool get isAuthenticated => _isAuthenticated;


  // AuthenticationProvider(this._databaseProvider, this._sharedPreferencesProvider);
  AuthenticationProvider(this._databaseProvider);

  Future<void> initDB(DatabaseProvider dbProvider) async {
    _databaseProvider = dbProvider;
    _isDbReady = true;
    if(_isSpReady) {
      _isReady = true;
      notifyListeners();
    }
  }


  Future<void> initSP(SharedPreferencesProvider spProvider) async {
    _sharedPreferencesProvider = spProvider;
    _isSpReady = true;
    if(_isDbReady) {
      _isReady = true;
      notifyListeners();
    }
  }


  /// Authenticate the user
  void authenticate() {
    _isAuthenticated = true;
    notifyListeners();
  }


  /// Logout the user
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }


  /// Register a new user with the given master password.<br>
  /// Create a derived key and store it securely.<br>
  /// Init the database, secured by the new key.<br>
  Future<void> registerNewUser(String masterPassword) async { // TODO : not called for the moment
    // Create a derived key from the master password
    final key = KeyGenerator.createDeriveKeyFromPassword(masterPassword);
    final keyString = KeyGenerator.keyToHex(key);

    // Store the derived key securely
    final storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'derived_key', value: keyString);
    } catch (e) {
      throw Exception('Failed to store the derived key securely: $e');
    }

    // Initialize the database with the derived key
    _databaseProvider.init(keyString); // will initialize the database -> DatabaseProvider will do the notifyListeners()
  }


  void authenticateUser(String masterPassword) {

  }


}

