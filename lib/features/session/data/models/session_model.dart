import 'package:hive/hive.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';

part 'session_model.g.dart';

@HiveType(typeId: 0)
class SessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final DateTime completedAt;

  SessionModel({
    required this.id,
    required this.startTime,
    required this.durationMinutes,
    required this.completedAt,
  });

  /// Converts from domain entity to Hive model.
  factory SessionModel.fromEntity(SessionEntity entity) {
    return SessionModel(
      id: entity.id,
      startTime: entity.startTime,
      durationMinutes: entity.durationMinutes,
      completedAt: entity.completedAt,
    );
  }

  /// Converts from Hive model to domain entity.
  SessionEntity toEntity() {
    return SessionEntity(
      id: id,
      startTime: startTime,
      durationMinutes: durationMinutes,
      completedAt: completedAt,
    );
  }

  /// Converts to JSON for Firestore.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  /// Converts from JSON for Firestore.
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
