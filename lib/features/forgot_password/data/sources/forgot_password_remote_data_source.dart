import 'package:dio/dio.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/features/auth/data/models/forgot_password_model.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<void> requestPasswordReset(String email);
  Future<ForgotPasswordModel> verifyResetToken(String token);
  Future<void> resetPassword(String token, String newPassword);
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final Dio dio;

  ForgotPasswordRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await dio.post('/auth/forgot-password/request', data: {
        'email': email,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        throw const ServerException(message: 'User not found for this email.');
      }
      throw ServerException(
          message: e.message ??
              'An error occurred while requesting password reset.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ForgotPasswordModel> verifyResetToken(String token) async {
    try {
      final response = await dio.post('/auth/forgot-password/verify', data: {
        'token': token,
      });
      return ForgotPasswordModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw const ServerException(message: 'Invalid or expired token.');
      }
      throw ServerException(
          message: e.message ?? 'An error occurred while verifying the token.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await dio.post('/auth/forgot-password/reset', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw const ServerException(message: 'Invalid or expired token.');
      }
      throw ServerException(
          message: e.message ?? 'An error occurred while resetting password.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
