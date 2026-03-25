import 'package:dio/dio.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/core/network/dio_client.dart';
import 'package:silent_space/features/auth/data/models/user_model.dart';

/// Contract for remote auth operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  const AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromLoginResponse(
        response.data as Map<String, dynamic>,
        email: email,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(
        message: e.message ?? 'An unknown error occurred during sign in.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/register',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromLoginResponse(
        response.data as Map<String, dynamic>,
        email: email,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(
        message: e.message ?? 'An unknown error occurred during sign up.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
