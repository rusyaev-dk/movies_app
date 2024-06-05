import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

void setupTalker() {
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);
  talker.debug("Talker started");
}
