class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });
  final String message;
  final int? statusCode;
  final String? errorCode;

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode, errorCode: $errorCode)';
}

class CacheException implements Exception {
  const CacheException({required this.message});
  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}

class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});
  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}
