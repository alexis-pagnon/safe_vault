
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/sha1.dart';
import 'dart:async';

import 'DatabaseProvider.dart';
import '../models/PasswordGenerator.dart';

class RobustnessProvider with ChangeNotifier {
  DatabaseProvider _databaseProvider;

  final List<int> _strongPasswords = [];
  final List<int> _weakPasswords = [];
  final List<int> _compromisedPasswords = [];
  final List<int> _reusedPasswords = [];

  final Map<String, bool> _compromisedCache = {};
  int _lastPasswordVersion = -1; // Track last password version to detect changes

  int _compromised = 0;
  int _weak = 0;
  int _reused = 0;
  int _strong = 0;
  int _totalScore = 0;

  RobustnessProvider(this._databaseProvider);

  int get compromised => _compromised;
  int get weak => _weak;
  int get reused => _reused;
  int get strong => _strong;
  int get totalScore => _totalScore;
  List<int> get strongPasswords => _strongPasswords;
  List<int> get weakPasswords => _weakPasswords;
  List<int> get compromisedPasswords => _compromisedPasswords;
  List<int> get reusedPasswords => _reusedPasswords;


  /// Update the database provider and re-analyze passwords if they have changed
  void updateDatabase(DatabaseProvider db) {
    _databaseProvider = db;
    if (db.passwordVersion != _lastPasswordVersion) {
      _lastPasswordVersion = db.passwordVersion;
      analyzeAllPwdRobustness();
    }
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
    _reusedPasswords.clear();

  }


  /// Analyze password robustness
  Future<void> analyzeAllPwdRobustness() async {
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
        if (groups[p.password]!.length > 1 && !reusedPwdFound.contains(p.password)) {
          _reused++;
          _reusedPasswords.add(p.id_pwd!);
          reusedPwdFound.add(p.password);
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
        double penalty = ( 100 * _reused + 250 * _compromised ) / totalPasswords;
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
      throw Exception('Failed to check compromised password');
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