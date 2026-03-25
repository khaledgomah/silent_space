import 'package:equatable/equatable.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<SessionEntity> sessions;

  const SessionLoaded({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class SessionError extends SessionState {
  final String message;

  const SessionError({required this.message});

  @override
  List<Object> get props => [message];
}
