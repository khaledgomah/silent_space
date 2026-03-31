import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/app/silent_space.dart';
import 'package:silent_space/core/notifications/notification_service.dart';
import 'package:silent_space/core/utils/bloc_observer.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await locatorSetup();
  await NotificationService().init();
  if (kDebugMode) {
    Bloc.observer = SimpleBlocObserver();
  }
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const SilentSpace(),
    ),
  );
}
