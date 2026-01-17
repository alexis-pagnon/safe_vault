
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/sha1.dart';
import 'dart:async';

import 'DatabaseProvider.dart';
import 'package:safe_vault/models/PasswordGenerator.dart';

class RobustnessProvider with ChangeNotifier {
  final DatabaseProvider _databaseProvider;

  bool _initialized = false;

  final List<int> _strongPasswords = [];
  final List<int> _weakPasswords = [];
  final List<int> _compromisedPasswords = [];
  final List<int> _allReusedPasswords = [];
  final List<int> _oldPasswords = [];

  final Map<String, bool> _compromisedCache = {};
  int _lastPasswordVersion = -1; // Track last password version to detect changes

  int _compromised = 0;
  int _weak = 0;
  int _reused = 0;
  int _strong = 0;
  int _totalScore = 0;

  final int _daysOldThreshold = 180; // days to consider a password old (6 months)

  RobustnessProvider(this._databaseProvider) {
    _databaseProvider.addListener(_onDatabaseChanged);
    _tryInitialAnalysis();
  }

  bool get initialized => _initialized;
  int get compromised => _compromised;
  int get weak => _weak;
  /// Number of unique reused passwords (not counting duplicates)
  int get reused => _reused;
  int get strong => _strong;
  int get totalScore => _totalScore;

  List<int> get strongPasswords => _strongPasswords;
  List<int> get weakPasswords => _weakPasswords;
  List<int> get compromisedPasswords => _compromisedPasswords;
  /// List of all reused password IDs (including duplicates)
  List<int> get allReusedPasswords => _allReusedPasswords;
  List<int> get oldPasswords => _oldPasswords;

  List<int> getNewOldPasswords(List<int> previousOldPasswords) {
    return _oldPasswords.where((id) => !previousOldPasswords.contains(id)).toList();
  }

  List<int> getNewCompromisedPasswords(List<int> previousCompromisedPasswords) {
    return _compromisedPasswords.where((id) => !previousCompromisedPasswords.contains(id)).toList();
  }


  /// Handle database changes
  void _onDatabaseChanged() {
    if (!_databaseProvider.isOpened) return;
    final version = _databaseProvider.passwordVersion;
    if (version == _lastPasswordVersion) return;
    _lastPasswordVersion = version;
    checkOldPasswords();
    analyzeAllPwdRobustness();
  }

  /// Try initial analysis if database is already opened
  Future<void> _tryInitialAnalysis() async {
    if (_databaseProvider.isOpened &&
        _lastPasswordVersion != _databaseProvider.passwordVersion) {
      _lastPasswordVersion = _databaseProvider.passwordVersion;
      await checkOldPasswords();
      await analyzeAllPwdRobustness();
      _initialized = true;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    _databaseProvider.removeListener(_onDatabaseChanged);
    super.dispose();
  }



  /// Reset all counts and lists
  void _reset() {
    _compromised = 0;
    _weak = 0;
    _reused = 0;
    _strong = 0;
    _totalScore = 0;

    _strongPasswords.clear();
    _weakPasswords.clear();
    _compromisedPasswords.clear();
    _allReusedPasswords.clear();

  }


  /// Analyze password robustness
  Future<void> analyzeAllPwdRobustness() async {

    if(!_databaseProvider.isOpened) {
      print("Error: Database is not opened");
      return;
    }

    // Reset counts
    _reset();

    try {
      final passwords = _databaseProvider.passwords;
      // Analyze each password

      // Reused passwords grouping
      final Map<String, List<int>> groups = {};
      for (final p in passwords) {
        groups.putIfAbsent(p.password, () => []).add(p.id_pwd!);
      }

      List<String> reusedPwdFound = [];

      // Analyze each password
      for (final p in passwords) {
        final entropy = PasswordGenerator.computeEntropyScore(p.password);

        // Strength categorization
        if (entropy <= 59) {
          _weak++;
          _weakPasswords.add(p.id_pwd!);
        } else {
          _strong++;
          _strongPasswords.add(p.id_pwd!);
        }

        // Reused password check
        if (groups[p.password]!.length > 1) {
          _allReusedPasswords.add(p.id_pwd!);
          if(!reusedPwdFound.contains(p.password)) {
            reusedPwdFound.add(p.password);
            _reused++;
          }
        }

        // Compromised check
        try {
          if (await isCompromisedCached(p.password)) {
            _compromised++;
            _compromisedPasswords.add(p.id_pwd!);
          }
        }
        catch (e) {
          print("Error checking compromised password: $e");
        }

      }

      // Compute total score
      int totalPasswords = _strong + _weak;
      if(totalPasswords > 0) {
        double baseScore = _strong / totalPasswords * 100;
        double penalty = (3 * _reused + _compromised)/baseScore*100;
        _totalScore = max(0, (baseScore - penalty)).round();
      } else {
        _totalScore = 100;
      }
    }
    catch (e) {
     print("Error: $e");
    }
    notifyListeners();
  }


  /// Check for old passwords.<br>
  /// Passwords older than [_daysOldThreshold] days are considered old
  Future<void> checkOldPasswords() async {
    if(!_databaseProvider.isOpened) {
      print("Error: Database is not opened");
      return;
    }

    try {
      final passwords = _databaseProvider.passwords;
      // TODO : Echanger ici Duration(days: _daysOldThreshold) avec Duration(seconds: 10) pour debugging
      int oldDateTreshold = DateTime.now().subtract(Duration(days: _daysOldThreshold)).millisecondsSinceEpoch;

      for (final p in passwords) {
        // Old password check
        if(p.last_update < oldDateTreshold) {
          if(!_oldPasswords.contains(p.id_pwd!)) {
            _oldPasswords.add(p.id_pwd!);
          }
        }
        else if(_oldPasswords.contains(p.id_pwd!)) {
          print("Password ID ${p.id_pwd} is no longer old, removing from old list.");
          _oldPasswords.remove(p.id_pwd!);
        }
      }
    }
    catch (e) {
      print("Error: $e");
    }
    notifyListeners();
  }



  /// Check if a password is compromised with caching
  Future<bool> isCompromisedCached(String password) async {
    if (_compromisedCache.containsKey(password)) {
      return _compromisedCache[password]!;
    }

    final result = await isCompromised(password);
    _compromisedCache[password] = result;
    return result;
  }

  /// Check if a password is compromised with the Have I Been Pwned API
  Future<bool> isCompromised(String password) async {
    try {
      // Get SHA-1 hash of the password
      final sha1 = SHA1Digest();
      final hash = sha1.process(utf8.encode(password));

      // Send hash to API and get compromised hashes

      Map<String, int> receivedHashes = await sendHashToServer(hash);

      if (receivedHashes.isNotEmpty) {
        List<String> hexCharacters = List.empty(growable: true);
        for (int i = 0; i < hash.length; i++) {
          hexCharacters.add(hash[i].toRadixString(16).padLeft(2, '0'));
        }
        String hashAsHex = hexCharacters.join("");
        // Remove the first 5 characters because they are not in the response
        String lastCharacters = hashAsHex.substring(5);

        if (receivedHashes.containsKey(lastCharacters.toUpperCase())) {
          return true;
        } else {
          return false;
        }
      }

    }
    catch (e) {
      throw Exception('Failed to check compromised password: $e');
    }
    return false;
  }


  /// Send the first 5 characters of the hash to the Have I Been Pwned API and return the compromised hashes
  Future<Map<String, int>> sendHashToServer(Uint8List hash) async {
    List<String> hexCharacters = List.empty(growable: true);
    // Convert hash to hexadecimal string
    for (int i = 0; i < hash.length; i++) {
      // Always 2 hex chars per byte
      hexCharacters.add(hash[i].toRadixString(16).padLeft(2, '0'));
    }
    // Join the hexadecimal characters to form the full hash string
    String hashAsHex = hexCharacters.join("");

    // Get the first 5 characters of the hash
    String first5characters = hashAsHex.substring(0, 5).toUpperCase();

    // Send request to the API
    final url = Uri.parse('https://api.pwnedpasswords.com/range/$first5characters');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the response and build the map of compromised hashes
      Map<String, int> mapHashes = {};
      List receivedHashes = response.body.split("\n");
      for (int i = 0; i < receivedHashes.length; i++) {
        String key = receivedHashes[i].split(":")[0].toString();
        int value = int.parse(receivedHashes[i].split(":")[1]);
        mapHashes[key] = value;
      }
      return mapHashes;
    } else {
      throw Exception('Failed to load data from API');
    }
  }


}