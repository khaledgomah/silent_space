import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final GetSessionsUseCase getSessionsUseCase;
  final SaveSessionUseCase saveSessionUseCase;

  SessionCubit({
    required this.getSessionsUseCase,
    required this.saveSessionUseCase,
  }) : super(SessionInitial());

  Future<void> loadSessions() async {
    emit(SessionLoading());
    final result = await getSessionsUseCase(NoParams());
    result.fold(
      (failure) => emit(SessionError(message: failure.message)),
      (sessions) => emit(SessionLoaded(sessions: sessions)),
    );
  }

  Future<void> saveSession(SessionEntity session) async {
    final result = await saveSessionUseCase(session);
    result.fold(
      (failure) => emit(SessionError(message: failure.message)),
      (session) => loadSessions(), // Reload sessions after save
    );
  }
}
