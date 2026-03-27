import 'package:get_it/get_it.dart';
import 'package:silent_space/core/network/dio_client.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/features/forgot_password/data/implements/forgot_password_repository_impl.dart';
import 'package:silent_space/features/forgot_password/data/sources/forgot_password_remote_data_source.dart';
import 'package:silent_space/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:silent_space/features/forgot_password/domain/usecases/request_password_reset_usecase.dart';
import 'package:silent_space/features/forgot_password/domain/usecases/reset_password_usecase.dart';
import 'package:silent_space/features/forgot_password/domain/usecases/verify_reset_token_usecase.dart';
import 'package:silent_space/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';

void setupForgotPasswordLocator(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(
        dio: getIt<DioClient>().dio), // Assuming DioClient exposes .dio
  );

  // Repositories
  getIt.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(
      remoteDataSource: getIt<ForgotPasswordRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(getIt<ForgotPasswordRepository>()),
  );
  getIt.registerLazySingleton<VerifyResetTokenUseCase>(
    () => VerifyResetTokenUseCase(getIt<ForgotPasswordRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<ForgotPasswordRepository>()),
  );

  // Cubit
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      requestPasswordResetUseCase: getIt<RequestPasswordResetUseCase>(),
      verifyResetTokenUseCase: getIt<VerifyResetTokenUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );
}
