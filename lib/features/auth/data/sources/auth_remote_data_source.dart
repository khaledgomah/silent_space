import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/features/auth/data/models/forgot_password_model.dart';
import 'package:silent_space/features/auth/data/models/user_model.dart';

/// Contract for remote auth operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> signInAnonymously();

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> linkAccountWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<bool> isLoggedIn();

  // Forgot Password API methods
  Future<void> requestPasswordReset(String email);
  Future<ForgotPasswordModel> verifyResetToken(String token);
  Future<void> resetPassword(String token, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final Dio? dio;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    this.dio,
  });

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final userCredential = await firebaseAuth.signInAnonymously();
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> linkAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      final userCredential = await firebaseAuth.currentUser?.linkWithCredential(credential);
      if (userCredential == null) {
        throw const ServerException(message: 'No anonymous user to link');
      }
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    if (dio == null) throw const ServerException(message: 'Dio client not initialized.');
    try {
      await dio!.post('/auth/forgot-password/request', data: {
        'email': email,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        throw const ServerException(message: 'User not found for this email.');
      }
      throw ServerException(
          message: e.message ?? 'An error occurred while requesting password reset.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ForgotPasswordModel> verifyResetToken(String token) async {
    if (dio == null) throw const ServerException(message: 'Dio client not initialized.');
    try {
      final response = await dio!.post('/auth/forgot-password/verify', data: {
        'token': token,
      });
      return ForgotPasswordModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw const ServerException(message: 'Invalid or expired token.');
      }
      throw ServerException(message: e.message ?? 'An error occurred while verifying the token.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    if (dio == null) throw const ServerException(message: 'Dio client not initialized.');
    try {
      await dio!.post('/auth/forgot-password/reset', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw const ServerException(message: 'Invalid or expired token.');
      }
      throw ServerException(message: e.message ?? 'An error occurred while resetting password.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
