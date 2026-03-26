import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import '../../../../fixtures/session_fixtures.dart';

void main() {
  group('SessionModel', () {
    final tModel = SessionFixtures.mockSessions.first;
    final tJson = SessionFixtures.mockSessionsJson.first;

    test('should be a subclass of FocusSession', () {
      // Assert
      expect(tModel.toEntity(), isA<FocusSession>());
    });

    test('fromJson - should return a valid model when the JSON is correct', () {
      // Act
      final result = SessionModel.fromJson(tJson);
      // Assert
      expect(result.id, tModel.id);
      expect(result.userId, tModel.userId);
      expect(result.durationInSeconds, tModel.durationInSeconds);
      expect(result.startTime.millisecondsSinceEpoch,
          tModel.startTime.millisecondsSinceEpoch);
    });

    test('toJson - should return a JSON map containing the proper data', () {
      // Act
      final result = tModel.toJson();
      // Assert
      expect(result['id'], tModel.id);
      expect(result['userId'], tModel.userId);
      expect(result['startTime'], isA<Timestamp>());
      expect(result['endTime'], isA<Timestamp>());
      expect(result['durationInSeconds'], tModel.durationInSeconds);
      expect(result['category'], tModel.category);
    });

    test('fromEntity - should return a valid model from entity', () {
      // Arrange
      final entity = tModel.toEntity();
      // Act
      final result = SessionModel.fromEntity(entity);
      // Assert
      expect(result.id, entity.id);
      expect(result.userId, entity.userId);
      expect(result.durationInSeconds, entity.durationInSeconds);
    });
  });
}
