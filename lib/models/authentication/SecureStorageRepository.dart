import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// Repository for securely storing and retrieving the derived database key.
class SecureStorageRepository {
  final FlutterSecureStorage _storage;

  SecureStorageRepository(this._storage);

  Future<void> saveDbKey(String key) =>
      _storage.write(key: 'derived_key', value: key);

  Future<String?> readDbKey() =>
      _storage.read(key: 'derived_key');

  Future<void> clear() =>
      _storage.delete(key: 'derived_key');
}