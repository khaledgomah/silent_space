import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';

class GetSessionsByDateRangeUseCase
    extends UseCase<List<FocusSession>, GetSessionsByDateRangeParams> {
  GetSessionsByDateRangeUseCase(this.repository);
  final SessionRepository repository;

  @override
  Future<Either<Failure, List<FocusSession>>> call(GetSessionsByDateRangeParams params) {
    return repository.getSessionsByDateRange(
      params.userId,
      params.startTime,
      params.endTime,
    );
  }
}

class GetSessionsByDateRangeParams extends Equatable {
  const GetSessionsByDateRangeParams({
    required this.userId,
    required this.startTime,
    required this.endTime,
  });
  final String userId;
  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object?> get props => [userId, startTime, endTime];
}
