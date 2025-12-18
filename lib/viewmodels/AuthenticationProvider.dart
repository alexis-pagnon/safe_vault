

import 'package:flutter/material.dart';
import 'package:safe_vault/models/authentication/KeyGenerator.dart';

import 'package:safe_vault/models/SharedPreferencesRepository.dart';
import 'package:safe_vault/models/authentication/SecureStorageRepository.dart';
import 'DatabaseProvider.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  final DatabaseProvider _databaseProvider;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final SecureStorageRepository _secureStorage;

  bool get isAuthenticated => _isAuthenticated;



  AuthenticationProvider({
    required DatabaseProvider databaseProvider,
    required SharedPreferencesRepository sharedPreferencesRepository,
    required SecureStorageRepository secureStorage,
  })  : _databaseProvider = databaseProvider,
        _sharedPreferencesRepository = sharedPreferencesRepository,
        _secureStorage = secureStorage;




  /// Logout the user
  void logout() {
    // TODO
    _isAuthenticated = false;
    notifyListeners();
  }


  /// Register a new user with the given master password.<br>
  /// Create a derived key and store it securely.<br>
  /// Init the database, secured by the new key.<br>
  Future<void> registerNewUser(String masterPassword) async { // TODO : not called for the moment

    final passwordHash = KeyGenerator.hashPassword(masterPassword);
    await _sharedPreferencesRepository.setHashedPassword(passwordHash);

    final dbKey = KeyGenerator.keyToHex(
      KeyGenerator.createDeriveKeyFromPassword(masterPassword),
    );

    await _secureStorage.saveDbKey(dbKey);
    await _databaseProvider.init(dbKey); // will initialize the database -> DatabaseProvider
    await _sharedPreferencesRepository.setFirstTime(false);

    _isAuthenticated = true;
    notifyListeners();

  }


  /// Authenticate the user
  Future<void> authenticate(String masterPassword) async {
    final passwordHash = KeyGenerator.hashPassword(masterPassword);
    final String savedHash = _sharedPreferencesRepository.hashedPassword ?? '';

    if (passwordHash != savedHash) {
      throw Exception('Invalid master password');
    }
    else {
      final dbKey = await _secureStorage.readDbKey();

      if(dbKey == null) {
        throw Exception('Database key not found');
      }
      else {
        await _databaseProvider.init(dbKey);
        _isAuthenticated = true;
        notifyListeners();
      }
    }
  }

}

