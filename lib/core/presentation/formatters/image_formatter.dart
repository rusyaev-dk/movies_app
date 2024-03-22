import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:movies_app/core/data/api/api_config.dart';

class ApiImageFormatter {
  static const _unknownFilmImagePath = "assets/images/unknown_film.png";

  static String get unknownFilmImagePath => _unknownFilmImagePath;

  static String formatImageUrl({required String path, int size = 500}) {
    return "${ApiConfig.imageUrl}/w$size$path";
  }

  static Future<bool> isImageAvailable(String imageUrl) async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file.existsSync();
  }

  static Widget formatImageWidget(
    BuildContext context, {
    required String? imagePath,
    double height = double.infinity,
    required double width,
  }) {
    Widget assetImageWidget = SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        _unknownFilmImagePath,
        fit: BoxFit.cover,
      ),
    );

    if (imagePath == null) return assetImageWidget;

    return CachedNetworkImage(
      imageUrl: formatImageUrl(path: imagePath),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      errorListener: (value) {
        // logging...
        print("Image Exception: $value");
      },
      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
      errorWidget: (context, url, error) {
        return assetImageWidget;
      },
    );
  }

  static ImageProvider<Object> formatImageProvider(
      {required String? imagePath}) {
    Object image = imagePath != null
        ? NetworkImage(formatImageUrl(path: imagePath))
        : const AssetImage(_unknownFilmImagePath);

    return image as ImageProvider<Object>;
  }
}
