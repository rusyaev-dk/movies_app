import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/data/api/api_config.dart';

class ApiImageFormatter {
  static String formatImageUrl({required String path, int size = 500}) {
    return "${ApiConfig.imageUrl}/w$size$path";
  }

  static const _unknownMediaLigthPath = "assets/images/unknown_media_light.png";
  static const _unknownMediaDarkPath = "assets/images/unknown_media_dark.png";

  static Widget formatImageWidget(
    BuildContext context, {
    required String? imagePath,
    double height = double.infinity,
    required double width,
  }) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    String unknownMediaPath;
    if (isDark) {
      unknownMediaPath = _unknownMediaDarkPath;
    } else {
      unknownMediaPath = _unknownMediaLigthPath;
    }

    Widget assetImageWidget = SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        unknownMediaPath,
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

  // static ImageProvider<Object> formatImageProvider(
  //     {required String? imagePath}) {
  //   Object image = imagePath != null
  //       ? NetworkImage(formatImageUrl(path: imagePath))
  //       : const AssetImage(_unknownFilmImagePath);

  //   return image as ImageProvider<Object>;
  // }
}
