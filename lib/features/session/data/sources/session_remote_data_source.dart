import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:silent_space/core/errors/exceptions.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';

/// Remote data source for session CRUD via Firestore.
abstract class SessionRemoteDataSource {
  Future<void> saveSession(SessionModel session);
  Future<List<SessionModel>> getSessionsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  );
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  SessionRemoteDataSourceImpl({required this.firestore});
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      firestore.collection('sessions');

  @override
  Future<void> saveSession(SessionModel session) async {
    try {
      // Use the provided ID or let Firestore generate one if null
      await _sessionsCollection.doc(session.id).set(session.toJson());
    } catch (e, stack) {
      debugPrint('Firestore Save Error: $e');
      debugPrint('Stack Trace: $stack');
      throw ServerException(message: 'Failed to save session to Firestore: $e');
    }
  }

  @override
  Future<List<SessionModel>> getSessionsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final snapshot = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      final sessions = snapshot.docs.map((doc) => SessionModel.fromJson(doc.data())).toList();

      // Sort in code to avoid requiring a composite index in Firestore
      sessions.sort((a, b) => b.startTime.compareTo(a.startTime));

      return sessions;
    } catch (e, stack) {
      debugPrint('Firestore Load Error: $e');
      debugPrint('Stack Trace: $stack');
      throw ServerException(message: 'Failed to load sessions from Firestore: $e');
    }
  }
}
