import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/security/secure_storage_service.dart';

/// Configures and provides a singleton [Dio] instance.
class DioClient {
  final SecureStorageService _secureStorage;
  late final Dio dio;

  DioClient({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://reqres.in/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    ]);
  }

  /// Injects the bearer token into every request if available.
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  /// Maps [DioException] to typed [ServerException].
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ServerException(
              message: 'Connection timed out. Please try again.',
              statusCode: error.response?.statusCode,
            );
          case DioExceptionType.connectionError:
            throw ServerException(
              message: 'Could not connect to the server.',
              statusCode: error.response?.statusCode,
            );
          default:
            throw ServerException(
              message: error.response?.data?['error']?.toString() ??
                  error.message ??
                  'An unexpected error occurred.',
              statusCode: error.response?.statusCode,
            );
        }
      },
    );
  }
}
