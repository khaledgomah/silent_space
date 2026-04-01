import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> deleteAccount();

  Future<bool> isLoggedIn();

  // Forgot Password methods
  Future<void> requestPasswordReset(String email);
  Future<ForgotPasswordModel> verifyResetToken(String token);
  Future<void> resetPassword(String token, String newPassword);

  // Social Sign-In
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final userCredential = await firebaseAuth.signInAnonymously();
      final token = await userCredential.user!.getIdToken();
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
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
      final token = await userCredential.user!.getIdToken();
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
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
      final token = await userCredential.user!.getIdToken();
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
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
      final token = await userCredential.user!.getIdToken();
      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
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
    await Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
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
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        // Force refresh the token to ensure the session is still valid
        final token = await user.getIdToken(true);
        return token != null;
      } catch (e) {
        // If token refresh fails, the session is likely invalid
        return false;
      }
    }
    return false;
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

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in dialog
        throw const ServerException(
          message: 'Google sign-in was cancelled.',
          errorCode: 'sign-in-cancelled',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final token = await userCredential.user!.getIdToken();

      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Google sign-in failed.',
        statusCode: 0,
        errorCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.cancelled) {
        throw const ServerException(
          message: 'Facebook sign-in was cancelled.',
          errorCode: 'sign-in-cancelled',
        );
      }

      if (loginResult.status == LoginStatus.failed) {
        throw ServerException(
          message: loginResult.message ?? 'Facebook sign-in failed.',
          errorCode: 'facebook-sign-in-failed',
        );
      }

      final accessToken = loginResult.accessToken!.tokenString;
      final credential = FacebookAuthProvider.credential(accessToken);
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final token = await userCredential.user!.getIdToken();

      return UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        token: token,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Facebook sign-in failed.',
        statusCode: 0,
        errorCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
