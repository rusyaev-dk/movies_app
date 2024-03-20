import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';

class MovieProductionInfo extends StatelessWidget {
  const MovieProductionInfo({
    super.key,
    required this.productionCountries,
    required this.runtime,
    required this.adult,
    this.releaseDate,
    this.textColor,
    this.fontSize = 14,
    this.maxLines = 3,
  });

  final List<ProductionCountry> productionCountries;
  final int runtime;
  final bool adult;
  final String? releaseDate;
  final Color? textColor;
  final double? fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    String additionalInfoString = "";
    if (releaseDate != null) {
      DateTime date = DateTime.parse(releaseDate!);
      additionalInfoString += "${date.year}, ";
    }

    if (productionCountries.isEmpty) {
      additionalInfoString = "Unknown country";
    } else {
      for (int i = 0; i < productionCountries.length; i++) {
        if (productionCountries[i].iso_3166_1 == null ||
            productionCountries[i].iso_3166_1!.isEmpty) continue;
        additionalInfoString += productionCountries[i].iso_3166_1!;
        if (i + 1 < productionCountries.length) additionalInfoString += ", ";
      }
    }

    additionalInfoString += ", ${runtime ~/ 60} h ${runtime % 60} min";
    if (adult) additionalInfoString += ", 18+";

    return Text(
      additionalInfoString,
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
