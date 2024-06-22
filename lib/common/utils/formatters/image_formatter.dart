import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/api/api_config.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
      errorListener: (value) {
        GetIt.I<Talker>().error("Exception caught: $value");
      },
      errorWidget: (context, url, error) {
        return assetImageWidget;
      },
    );
  }

  static Widget formatAvatarImageWidget(
    BuildContext context, {
    required String? imagePath,
    required double diameter,
  }) {
    final double borderRadiusValue = diameter / 2.0;
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    String unknownMediaPath;
    if (isDark) {
      unknownMediaPath = _unknownMediaDarkPath;
    } else {
      unknownMediaPath = _unknownMediaLigthPath;
    }

    Widget assetImageWidget = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
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
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
        );
      },
      errorListener: (value) {
        GetIt.I<Talker>().error("Exception caught: $value");
      },
      errorWidget: (context, url, error) {
        return assetImageWidget;
      },
    );
  }

  static Widget formatImageWidgetWithAspectRatio(
    BuildContext context, {
    required String? imagePath,
    required double aspectRatio,
    required double width,
    required double height,
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
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
      errorListener: (value) {
        GetIt.I<Talker>().error("Exception caught: $value");
      },
      errorWidget: (context, url, error) {
        return assetImageWidget;
      },
    );
  }
}
