import 'package:easy_localization/easy_localization.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/utils/app_strings.dart';

class FailureMapper {
  static String map(Failure failure) {
    if (failure is NetworkFailure) return AppStrings.noConnection.tr();

    if (failure is AuthFailure || failure is ServerFailure) {
      // Map common Firebase/Server error codes to translations
      final code = failure.errorCode;

      if (code == 'invalid-credential' ||
          code == 'wrong-password' ||
          code == 'user-not-found') {
        return AppStrings.invalidCredentials.tr();
      }

      if (code == 'invalid-email') {
        return AppStrings.invalidEmail.tr();
      }

      if (code == 'email-already-in-use') {
        return AppStrings.emailAlreadyInUse.tr();
      }

      if (code == 'weak-password') {
        return AppStrings.weakPassword.tr();
      }

      if (failure.statusCode == 400 &&
          (failure.message.isEmpty || failure.message == 'null')) {
        return AppStrings.invalidCredentials.tr();
      }

      return failure.message.isNotEmpty && failure.message != 'null'
          ? failure.message
          : AppStrings.unknownError.tr();
    }

    return AppStrings.unknownError.tr();
  }
}
