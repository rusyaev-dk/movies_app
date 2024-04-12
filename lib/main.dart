import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/core/utils/logger.dart';
import 'package:movies_app/movies_app.dart';

void main() async {
  setupLogger();
  
  await dotenv.load(fileName: ".env");

  final KeyValueStorage sharedPrefsStorage = KeyValueStorage();
  await sharedPrefsStorage.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MoviesApp(sharedPrefsStorage: sharedPrefsStorage));
}
