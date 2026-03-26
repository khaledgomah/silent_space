import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_by_date_range_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final SaveSessionUseCase saveSessionUseCase;
  final GetSessionsByDateRangeUseCase getSessionsByDateRangeUseCase;

  SessionCubit({
    required this.saveSessionUseCase,
    required this.getSessionsByDateRangeUseCase,
  }) : super(const SessionInitial());

  Future<void> saveSession(FocusSession session) async {
    final result = await saveSessionUseCase(session);
    result.fold(
      (failure) => emit(SessionError(message: failure.message)),
      (_) => null, // Successfully saved locally and remotely
    );
  }

  Future<void> loadSessions({
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    emit(const SessionLoading());

    final result = await getSessionsByDateRangeUseCase(
      GetSessionsByDateRangeParams(
        userId: userId,
        startTime: startTime,
        endTime: endTime,
      ),
    );

    result.fold(
      (failure) => emit(SessionError(message: failure.message)),
      (sessions) => emit(SessionLoaded(sessions)),
    );
  }
}
