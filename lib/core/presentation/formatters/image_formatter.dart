import 'package:flutter/material.dart';
import 'package:movies_app/core/data/api/api_config.dart';
import 'package:movies_app/core/utils/app_constants.dart';

class ApiImageFormatter {
  static String formatImageUrl({required String path, int size = 500}) {
    return "${ApiConfig.imageUrl}/w$size$path";
  }

  static Widget formatImageWidget(BuildContext context, {required String? imagePath}) {
    Image assetImage = Image.asset(
      AppConstants.unknownFilmImagePath,
      fit: BoxFit.cover,
    );
    return imagePath != null
        ? Image.network(
            formatImageUrl(path: imagePath),
            fit: BoxFit.cover,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              // logging...
              return assetImage;
            },
          )
        : assetImage;
  }

  static ImageProvider<Object> formatImageProvider(
      {required String? imagePath}) {
    Object image = imagePath != null
        ? NetworkImage(
            ApiImageFormatter.formatImageUrl(path: imagePath),
          )
        : const AssetImage(AppConstants.unknownFilmImagePath);
    return image as ImageProvider<Object>;
  }
}
