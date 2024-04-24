import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/themes/theme.dart';

class MediaGenresText extends StatelessWidget {
  const MediaGenresText({
    super.key,
    required this.mediaGenres,
    this.textColor,
    this.fontSize = 14,
    this.maxLines = 3,
    this.centerText = false,
  });

  final List<String> mediaGenres;
  final Color? textColor;
  final double? fontSize;
  final int maxLines;
  final bool centerText;

  @override
  Widget build(BuildContext context) {
    if (mediaGenres.isEmpty) {
      return Text(
        "Unknown genre",
        maxLines: maxLines,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .subtitleTextStyle
            .copyWith(
              overflow: TextOverflow.ellipsis,
              color: textColor ?? Theme.of(context).colorScheme.secondary,
              fontSize: fontSize,
            ),
      );
    }

    String genresString = "";

    for (int i = 0; i < mediaGenres.length; i++) {
      if (mediaGenres[i].isEmpty) continue;
      genresString += mediaGenres[i];
      if (i + 1 < mediaGenres.length) genresString += ", ";
    }

    return Text(
      genresString,
      textAlign: centerText ? TextAlign.center : null,
      maxLines: maxLines,
      style: Theme.of(context)
          .extension<ThemeTextStyles>()!
          .subtitleTextStyle
          .copyWith(
            overflow: TextOverflow.ellipsis,
            color: textColor ?? Theme.of(context).colorScheme.secondary,
            fontSize: fontSize,
          ),
    );
  }
}
