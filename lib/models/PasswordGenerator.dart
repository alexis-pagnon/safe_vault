
import 'dart:math';

class PasswordGenerator {

  /// Generate a random password
  static String generateRandomPassword(int nbChars, bool useLowercase, bool useUppercase, bool useNumbers, bool useSpecialChars) {

    if(nbChars <= 0) {
      throw ArgumentError("Password length must be greater than 0.");
    }
    if(!useLowercase && !useUppercase && !useNumbers && !useSpecialChars) {
      throw ArgumentError("At least one character type must be selected.");
    }

    String password = "";
    const String lowercaseChars = "abcdefghijklmnopqrstuvwxyz";
    const String uppercaseChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const String numberChars = "0123456789";
    const String specialChars = "!@#\$%^&*()-_=+[{]}|;:'\"<,>.?/~";

    String charPool = "";
    charPool += useLowercase ? lowercaseChars : "";
    charPool += useUppercase ? uppercaseChars : "";
    charPool += useNumbers ? numberChars : "";
    charPool += useSpecialChars ? specialChars : "";

    late Random rand;
    try {
      rand = Random.secure();
    }
    catch (e) {
      // Fallback to less secure random generator
      print("Warning: Secure random generator not available. Falling back to less secure generator.");
      rand = Random();
    }

    for(int i = 0; i <  nbChars; i++) {
      int index = rand.nextInt(charPool.length);
      password += charPool[index];
    }

    Map<String, dynamic> analysis = completePasswordStrengthAnalysis(password);
    while(analysis["uppercase"] != useUppercase ||
        analysis["numbers"] != useNumbers ||
        analysis["specialChars"] != useSpecialChars) {
      // Regenerate password until it meets the criteria
      password = "";
      for(int i = 0; i <  nbChars; i++) {
        int index = rand.nextInt(charPool.length);
        password += charPool[index];
      }
      analysis = completePasswordStrengthAnalysis(password);
    }

    return password;
  }

  /// Compute entropy score of a password
  static double computeEntropyScore(String password) {
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

    if (R == 0 || L == 0) return 0.0;
    // Entropy = log(pow(R, L))/log(2) = L * log(R) / log(2) to avoid integer overflow
    return L * log(R) / log(2);

  }

  /// Complete password strength analysis<br>
  /// @param password The password to analyze<br>
  /// @return A map containing the strength and criteria met (strength, length >= 12, uppercase, numbers, specialChars)
  static Map<String, dynamic> completePasswordStrengthAnalysis(String password) {
    double entropy = computeEntropyScore(password);
    String strength;
    if (entropy < 28) {
      strength = "Très faible";
    } else if (entropy < 36) {
      strength = "Faible";
    } else if (entropy < 60) {
      strength = "Moyen";
    } else if (entropy < 128) {
      strength = "Fort";
    } else {
      strength = "Très fort";
    }

    return {
      "strength": strength,
      "length": password.length >= 12,
      "uppercase": password.contains(RegExp(r'[A-Z]')),
      "numbers": password.contains(RegExp(r'[0-9]')),
      "specialChars":
      password.contains(RegExp(r'[!@#$%^&*()\-_=+\[\]{}|;:"<,>.?/~]')) ||
          password.contains(RegExp(r"'")),
    };
  }

}