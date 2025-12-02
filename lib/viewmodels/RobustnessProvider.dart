
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'DatabaseProvider.dart';

class RobustnessProvider with ChangeNotifier {
  final DatabaseProvider databaseProvider;
  int _compromised = 0;
  int _weak = 0;
  int _reused = 0;
  int _strong = 0;
  int _totalScore = 0;

  RobustnessProvider({required this.databaseProvider});

  int get compromised => _compromised;
  int get weak => _weak;
  int get reused => _reused;
  int get strong => _strong;
  int get totalScore => _totalScore;

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

        // Compromised check
        if(isCompromised(passwordEntry.password)) {
          _compromised++;
        }

        // Strength categorization
        if(entropyScore <= 59) {
          _weak++;
        }
        else if(entropyScore >= 60) {
          _strong++;
        }
      }

      // Count reused passwords
      seenPasswords.forEach((key, value) {
        if(value > 1) {
          _reused += value;
        }
      });

      // Compute total score
      _totalScore = (_strong * 2) - (_weak + _compromised + _reused); // TODO: Refine scoring algorithm
      notifyListeners();
    }
    catch (e) {
      print("Error: $e");
      notifyListeners();
      return;
    }
  }

  /// Check if a password is compromised with the Have I Been Pwned API
  bool isCompromised(String password) {
    try {
      // TODO

    }
    catch (e) {
      print("Error checking compromised password: $e");
    }
    return false;
  }


}