
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/sha1.dart';
import 'package:safe_vault/models/database/Password.dart';
import 'dart:async';

import 'DatabaseProvider.dart';

class RobustnessProvider with ChangeNotifier {
  final DatabaseProvider databaseProvider;
  int _compromised = 0;
  int _weak = 0;
  int _reused = 0;
  int _strong = 0;
  int _totalScore = 0;

  final List<int> _strongPasswords = [];
  final List<int> _weakPasswords = [];
  final List<int> _compromisedPasswords = [];
  final List<int> _reusedPasswords = [];

  RobustnessProvider({required this.databaseProvider});

  int get compromised => _compromised;
  int get weak => _weak;
  int get reused => _reused;
  int get strong => _strong;
  int get totalScore => _totalScore;
  List<int> get strongPasswords => _strongPasswords;
  List<int> get weakPasswords => _weakPasswords;
  List<int> get compromisedPasswords => _compromisedPasswords;
  List<int> get reusedPasswords => _reusedPasswords;

  /// Compute entropy score of a password
  double computeEntropyScore(String password) {
    int R = 0; // Size of the character set
    int L = password.length;

    // Determine the character set size
    bool hasLower = false;
    bool hasUpper = false;
    bool hasDigit = false;
    bool hasSpecial = false;
    for(var char in password.codeUnits) {
      if(char >= 97 && char <= 122) { // a-z
        hasLower = true;
      }
      else if(char >= 65 && char <= 90) { // A-Z
        hasUpper = true;
      }
      else if(char >= 48 && char <= 57) { // 0-9
        hasDigit = true;
      }
      else { // Special characters
        hasSpecial = true;
      }

      if(hasLower && hasUpper && hasDigit && hasSpecial) {
        break;
      }
    }

    if(hasLower) R += 26;
    if(hasUpper) R += 26;
    if(hasDigit) R += 10;
    if(hasSpecial) R += 30; // !, @, #, $, %, ^, &, *, (, ), -, _, =, +, [, {, ], }, |, ;, :, ', ", <, ,, >, ., ?, /, ~

    return log(pow(R, L))/log(2);
  }

  /// Analyze password robustness
  Future<void> analyzeAllPwdRobustness() async {
    // Reset counts
    _compromised = 0;
    _weak = 0;
    _reused = 0;
    _strong = 0;
    _totalScore = 0;

    // Fetch passwords from the database
    var db = databaseProvider;

    try {
      var passwords = await db.retrievePasswords();
      // Analyze each password

      Map<String,int> seenPasswords = {};

      for(var passwordEntry in passwords) {
        double entropyScore = computeEntropyScore(passwordEntry.password);

        // Reused password check
        if(seenPasswords.keys.contains(passwordEntry.password)) {
          seenPasswords[passwordEntry.password] = seenPasswords[passwordEntry.password]! + 1;
        }
        else {
          seenPasswords[passwordEntry.password] = 1;
        }

        try {
          // Compromised check
          if(await isCompromised(passwordEntry.password)) {
            _compromised++;

            if(!_compromisedPasswords.contains(passwordEntry.id_pwd)) {
              _compromisedPasswords.add(passwordEntry.id_pwd);
            }
          }
        }
        catch (e) {
          print("Error checking compromised password: $e");
        }

        // Strength categorization
        if(entropyScore <= 59) {
          _weak++;
          if(!_weakPasswords.contains(passwordEntry.id_pwd)) {
            _weakPasswords.add(passwordEntry.id_pwd);
          }
        }
        else if(entropyScore > 59) {
          _strong++;
          if(!_strongPasswords.contains(passwordEntry.id_pwd)) {
            _strongPasswords.add(passwordEntry.id_pwd);
          }
        }
      }

      // Count reused passwords
      seenPasswords.forEach((key, value) {
        if(value > 1) {
          _reused += 1;
          for(var passwordEntry in passwords) {
            if(passwordEntry.password == key) {
              if(!_reusedPasswords.contains(passwordEntry.id_pwd)) {
                _reusedPasswords.add(passwordEntry.id_pwd);
              }
            }
          }
        }
      });

      // Compute total score
      int totalPasswords = _strong + _weak;
      if(totalPasswords > 0) {
        double baseScore = _strong / totalPasswords * 100;
        double penalty = ( 100 * _reused + 250 * _compromised ) / totalPasswords;

        _totalScore = max(0, (baseScore - penalty)).round();

      } else {
        _totalScore = 100;
      }

      notifyListeners();
    }
    catch (e) {
      print("Error: $e");
      notifyListeners();
      return;
    }
  }


  /// Analyze robustness of a single password
  Future<void> analyzeSinglePwdRobustness(Password password) async {
    // Compute entropy score
    double entropyScore = computeEntropyScore(password.password);

    // Reused password check
    var db = databaseProvider;
    var passwords = await db.retrievePasswords();

    for(var passwordEntry in passwords) {
      if(passwordEntry.password == password.password) {
        _reused += 1;

        if(!_reusedPasswords.contains(password.id_pwd)) {
          _reusedPasswords.add(password.id_pwd);
        }

        break;
      }
    }


    // Compromised check
    try {
      if(await isCompromised(password.password)) {
        _compromised++;
        if(!_strongPasswords.contains(password.id_pwd)) {
          _strongPasswords.add(password.id_pwd);
        }
      }
    }
    catch (e) {
      print("Error checking compromised password: $e");
    }

    // Strength categorization
    if(entropyScore <= 59) {
      _weak++;
      if(!_weakPasswords.contains(password.id_pwd)) {
        _weakPasswords.add(password.id_pwd);
      }
    }
    else if(entropyScore > 59) {
      _strong++;
      if(!_strongPasswords.contains(password.id_pwd)) {
        _strongPasswords.add(password.id_pwd);
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

    notifyListeners();
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