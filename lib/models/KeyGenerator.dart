
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

class KeyGenerator {

  /// Create a derived key from a password.<br>
  /// This function generates a random salt and derives a key using PBKDF2.<br>
  /// The returned key is a Uint8List of the derived key bytes.<br>
  static Uint8List createDeriveKeyFromPassword(String password) {

    final salt = generateSalt();
    final key = deriveKeyPBKDF2(
      password: password,
      salt: salt,
      iterations: 100000,
      keyLength: 32,
    );

    return key;
  }


  /// Convert a key (Uint8List) to a hexadecimal string
  static String keyToHex(Uint8List key) {
    return hex.encode(key);
  }

  /// Derive a key from a password using PBKDF2 with HMAC-SHA256
  static Uint8List deriveKeyPBKDF2({
    required String password,
    required Uint8List salt,
    int iterations = 100000,
    int keyLength = 32,
  }) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, iterations, keyLength));

    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }


  /// Generate a random salt of specified length
  static Uint8List generateSalt([int length = 16]) {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(KeyParameter(Uint8List.fromList(List<int>.generate(
        32,
            (_) => DateTime.now().microsecondsSinceEpoch % 256,
      ))));

    return secureRandom.nextBytes(length);
  }


}