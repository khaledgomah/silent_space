import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';

part 'session_model.g.dart';

@HiveType(typeId: 0)
class SessionModel extends HiveObject {
  SessionModel({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationInSeconds,
    required this.category,
    this.needsSync = false,
  });

  /// Converts from domain entity to model.
  factory SessionModel.fromEntity(FocusSession entity, {bool needsSync = false}) {
    return SessionModel(
      id: entity.id,
      userId: entity.userId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationInSeconds: entity.durationInSeconds,
      category: entity.category,
      needsSync: needsSync,
    );
  }

  /// Converts from JSON for Firestore handling both Timestamps and ISO Strings.
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startTime: _parseDateTime(json['startTime']),
      endTime: _parseDateTime(json['endTime']),
      durationInSeconds: json['durationInSeconds'] as int,
      category: json['category'] as String,
      needsSync: json['needsSync'] as bool? ?? false,
    );
  }
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime endTime;

  @HiveField(4)
  final int durationInSeconds;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final bool needsSync;

  /// Converts from model to domain entity.
  FocusSession toEntity() {
    return FocusSession(
      id: id,
      userId: userId,
      startTime: startTime,
      endTime: endTime,
      durationInSeconds: durationInSeconds,
      category: category,
    );
  }

  SessionModel copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationInSeconds,
    String? category,
    bool? needsSync,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      category: category ?? this.category,
      needsSync: needsSync ?? this.needsSync,
    );
  }

  /// Converts to JSON for Firestore with Timestamps.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'durationInSeconds': durationInSeconds,
      'category': category,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Invalid DateTime format: $value');
    }
  }
}
