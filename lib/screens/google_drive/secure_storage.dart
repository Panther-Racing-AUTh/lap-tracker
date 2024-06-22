import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<void> saveCredentials(AccessToken accessToken, String refreshToken) async {
    await _storage.write(key: 'type', value: accessToken.type);
    await _storage.write(key: 'data', value: accessToken.data);
    await _storage.write(key: 'expiry', value: accessToken.expiry.toIso8601String());
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<Map<String, String>?> getCredentials() async {
    var result = await _storage.readAll();
    if (result.containsKey('type') && result.containsKey('data') && result.containsKey('expiry') && result.containsKey('refreshToken')) {
      return result;
    }
    return null;
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
