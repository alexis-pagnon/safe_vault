

import 'package:flutter/material.dart';
import 'package:safe_vault/models/authentication/KeyGenerator.dart';
import 'package:safe_vault/models/SharedPreferencesRepository.dart';
import 'package:safe_vault/models/authentication/SecureStorageRepository.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';

import 'package:local_auth/local_auth.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  final DatabaseProvider _databaseProvider;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final SecureStorageRepository _secureStorage;

  bool _canUseBiometrics = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get canUseBiometrics => _canUseBiometrics;


  AuthenticationProvider({
    required DatabaseProvider databaseProvider,
    required SharedPreferencesRepository sharedPreferencesRepository,
    required SecureStorageRepository secureStorage,
  })  : _databaseProvider = databaseProvider,
        _sharedPreferencesRepository = sharedPreferencesRepository,
        _secureStorage = secureStorage {
    _initBiometrics();
  }




  /// Logout the user
  void logout() { // TODO
    _isAuthenticated = false;
    notifyListeners();
  }


  /// Register a new user with the given master password.<br>
  /// Create a derived key and store it securely.<br>
  /// Init the database, secured by the new key.<br>
  Future<void> registerNewUser(String masterPassword) async {

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

  void _initBiometrics() async {
    final localAuth = LocalAuthentication();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();

    if(canCheckBiometrics && isDeviceSupported) {
      _canUseBiometrics = true;
    }
    else {
      _canUseBiometrics = false;
    }
    notifyListeners();
  }


  /// Authenticate using biometrics
  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      throw Exception('Biometric authentication not available');
    }

    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to access your vault',
        biometricOnly: true,
      );

      if (didAuthenticate) {
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
    } catch (e) {
      print('Error checking biometrics: $e');
    }

  }



}

