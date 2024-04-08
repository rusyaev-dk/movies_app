import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/movies_app.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final KeyValueStorage sharedPrefsStorage = KeyValueStorage();
  await sharedPrefsStorage.init();

  runApp(MoviesApp(
    sharedPrefsStorage: sharedPrefsStorage,
  ));
}
