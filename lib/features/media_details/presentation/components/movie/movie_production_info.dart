import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/themes/theme.dart';
import 'package:movies_app/core/utils/data_formatter.dart';

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
    String productionInfoString = "";
    if (DataFormatter.isCorrectDateString(releaseDate)) {
      productionInfoString +=
          "${DataFormatter.getYearFromDate(releaseDate!)}, ";
    }

    if (productionCountries.isEmpty) {
      productionInfoString = "Unknown country";
    } else {
      for (int i = 0; i < productionCountries.length; i++) {
        if (productionCountries[i].iso_3166_1 == null ||
            productionCountries[i].iso_3166_1!.isEmpty) continue;
        productionInfoString += productionCountries[i].iso_3166_1!;
        if (i + 1 < productionCountries.length) productionInfoString += ", ";
      }
    }

    productionInfoString += ", ${runtime ~/ 60} h ${runtime % 60} min";
    if (adult) productionInfoString += ", 18+";

    return Text(
      productionInfoString,
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
