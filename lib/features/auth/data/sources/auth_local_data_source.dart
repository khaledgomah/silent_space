import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/security/secure_storage_service.dart';

/// Contract for local auth token operations.
abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService secureStorage;

  const AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheToken(String token) async {
    try {
      await secureStorage.saveToken(token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache auth token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.readToken();
    } catch (e) {
      throw CacheException(message: 'Failed to read auth token: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await secureStorage.deleteToken();
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth token: $e');
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      return await secureStorage.hasToken();
    } catch (e) {
      return false;
    }
  }
}
