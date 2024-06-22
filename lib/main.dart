import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/di/dependencies_register.dart';
import 'package:movies_app/common/utils/logger_setup.dart';
import 'package:movies_app/movies_app.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  setupLogger();
  final Talker talker = GetIt.I<Talker>();

  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    talker.handle(exception, stackTrace);
    return true;
  };

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  FlutterError.onError =
      (details) => talker.handle(details.exception, details.stack);

  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await dotenv.load(fileName: ".env");
      await registerDependencies();

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      runApp(const MoviesApp());
    },
    (error, stackTrace) => talker.handle(error, stackTrace),
  );
}
