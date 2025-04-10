import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // This uses platform-specific secure storage
  static const _accessKey = 'ACCESS_TOKEN';
  static const _refreshKey = 'REFRESH_TOKEN';

  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<String?> readAccessToken() async {
    return _storage.read(key: _accessKey);
  }

  Future<String?> readRefreshToken() async {
    return _storage.read(key: _refreshKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
