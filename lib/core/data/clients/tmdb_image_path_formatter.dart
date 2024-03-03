import 'package:movies_app/core/data/clients/tmdb_config.dart';

class TMDBImageFormatter {
  static String formatImageUrl({required String path, int size = 500}) {
    return "${TMDBConfig.imageUrl}/w$size$path";
  }
}
