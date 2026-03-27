import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/cache/hive_service.dart';
import 'package:silent_space/core/network/dio_client.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/core/security/secure_storage_service.dart';
import 'package:silent_space/core/utils/forgot_password_service_locator.dart';
import 'package:silent_space/features/auth/data/implements/auth_repository_impl.dart';
import 'package:silent_space/features/auth/data/sources/auth_local_data_source.dart';
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/link_account_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:silent_space/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/session/data/implements/session_repository_impl.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';
import 'package:silent_space/features/session/data/sources/session_local_data_source.dart';
import 'package:silent_space/features/session/data/sources/session_remote_data_source.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_by_date_range_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';

GetIt getIt = GetIt.instance;

Future<void> locatorSetup() async {
  // ── SharedPreferences ──
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // ── Security ──
  getIt.registerLazySingleton<SecureStorageService>(
    () => const SecureStorageService(),
  );

  // ── Network ──
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: Connectivity()),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(secureStorage: getIt<SecureStorageService>()),
  );

  // ── Cache ──
  final hiveService = HiveService();
  await hiveService.init();
  getIt.registerSingleton<HiveService>(hiveService);

  // ── Auth Feature ──
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt<SecureStorageService>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<SignInAnonymouslyUseCase>(
    () => SignInAnonymouslyUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LinkAccountUseCase>(
    () => LinkAccountUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepository>()),
  );

  // ── Session Feature ──
  // Register Hive adapter
  Hive.registerAdapter(SessionModelAdapter());

  getIt.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourceImpl(hiveService: getIt<HiveService>()),
  );

  getIt.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      localDataSource: getIt<SessionLocalDataSource>(),
      remoteDataSource: getIt<SessionRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<SaveSessionUseCase>(
    () => SaveSessionUseCase(getIt<SessionRepository>()),
  );

  getIt.registerLazySingleton<GetSessionsByDateRangeUseCase>(
    () => GetSessionsByDateRangeUseCase(getIt<SessionRepository>()),
  );

  // ── Forgot Password Feature ──
  setupForgotPasswordLocator(getIt);

  // ── Presentation BLoC/Cubit ──
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInAnonymouslyUseCase: getIt<SignInAnonymouslyUseCase>(),
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      linkAccountUseCase: getIt<LinkAccountUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  getIt.registerFactory<SessionCubit>(
    () => SessionCubit(
      getSessionsByDateRangeUseCase: getIt<GetSessionsByDateRangeUseCase>(),
      saveSessionUseCase: getIt<SaveSessionUseCase>(),
    ),
  );
}
