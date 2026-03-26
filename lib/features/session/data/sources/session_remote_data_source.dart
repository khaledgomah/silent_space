import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';

/// Remote data source for session CRUD via Firestore.
abstract class SessionRemoteDataSource {
  Future<void> saveSession(SessionModel session);
  Future<List<SessionModel>> getSessions();
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SessionRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  CollectionReference<Map<String, dynamic>> get _sessionsCollection {
    final user = auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User not authenticated');
    }
    return firestore.collection('users').doc(user.uid).collection('sessions');
  }

  @override
  Future<void> saveSession(SessionModel session) async {
    try {
      await _sessionsCollection.doc(session.id).set(session.toJson());
    } catch (e) {
      throw ServerException(message: 'Failed to save session to Firestore: $e');
    }
  }

  @override
  Future<List<SessionModel>> getSessions() async {
    try {
      final snapshot = await _sessionsCollection
          .orderBy('completedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => SessionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(
          message: 'Failed to load sessions from Firestore: $e');
    }
  }
}
