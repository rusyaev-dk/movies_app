// ignore_for_file: avoid_print

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

void setupLogger() {
  AnsiPen redPen = AnsiPen()..red();
  AnsiPen bluePen = AnsiPen()..blue();
  AnsiPen greenPen = AnsiPen()..green();
  AnsiPen yellowPen = AnsiPen()..yellow();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (record.level == Level.SEVERE) {
      print(redPen('${record.level.name}: ${record.time}: ${record.message}'));
    } else if (record.level == Level.WARNING) {
      print(bluePen('${record.level.name}: ${record.time}: ${record.message}'));
    } else if (record.level == Level.INFO) {
      print(
          greenPen('${record.level.name}: ${record.time}: ${record.message}'));
    } else {
      print(
          yellowPen('${record.level.name}: ${record.time}: ${record.message}'));
    }
  });
}
