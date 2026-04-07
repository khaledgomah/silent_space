import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/cache/hive_service.dart';
import 'package:silent_space/core/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/core/security/secure_storage_service.dart';
import 'package:silent_space/core/theme/theme_cubit.dart';
import 'package:silent_space/features/auth/data/implements/auth_repository_impl.dart';
import 'package:silent_space/features/auth/data/sources/auth_local_data_source.dart';
import 'package:silent_space/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:silent_space/features/auth/domain/repositories/auth_repository.dart';
import 'package:silent_space/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/link_account_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:silent_space/features/auth/domain/usecases/verify_reset_token_usecase.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/session/data/implements/session_repository_impl.dart';
import 'package:silent_space/features/session/data/models/session_model.dart';
import 'package:silent_space/features/session/data/sources/session_local_data_source.dart';
import 'package:silent_space/features/session/data/sources/session_remote_data_source.dart';
import 'package:silent_space/features/session/domain/repositories/session_repository.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_by_date_range_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

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

  // ── Cache ──
  final hiveService = HiveService();
  await hiveService.init();
  getIt.registerSingleton<HiveService>(hiveService);

  // ── Auth Feature ──
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt<SecureStorageService>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      sessionRepository: getIt<SessionRepository>(),
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

  getIt.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<VerifyResetTokenUseCase>(
    () => VerifyResetTokenUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<IsLoggedInUseCase>(
    () => IsLoggedInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
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

  // ── Global Cubits (Singletons) ──
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<TimerCubit>(() => TimerCubit());

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
    ),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      requestPasswordResetUseCase: getIt<RequestPasswordResetUseCase>(),
      verifyResetTokenUseCase: getIt<VerifyResetTokenUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );

  getIt.registerFactory<SessionCubit>(
    () => SessionCubit(
      getSessionsByDateRangeUseCase: getIt<GetSessionsByDateRangeUseCase>(),
      saveSessionUseCase: getIt<SaveSessionUseCase>(),
    ),
  );

  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<IsLoggedInUseCase>()),
  );
}
