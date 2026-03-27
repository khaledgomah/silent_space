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

  // Forgot Password methods
  Future<void> requestPasswordReset(String email);
  Future<ForgotPasswordModel> verifyResetToken(String token);
  Future<void> resetPassword(String token, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
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
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An error occurred while requesting password reset.',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ForgotPasswordModel> verifyResetToken(String token) async {
    try {
      final email = await firebaseAuth.verifyPasswordResetCode(token);
      return ForgotPasswordModel(
        email: email,
        token: token,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An error occurred while verifying the token.',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await firebaseAuth.confirmPasswordReset(
        code: token,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An error occurred while resetting password.',
        statusCode: 0,
        errorCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
