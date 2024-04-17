import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';

class TVSeriesProductionInfo extends StatelessWidget {
  const TVSeriesProductionInfo({
    super.key,
    required this.productionCountries,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.episodesRunTime,
    required this.adult,
    this.firstAirDate,
    this.textColor,
    this.fontSize = 14,
    this.maxLines = 3,
  });

  final List<ProductionCountry> productionCountries;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<dynamic> episodesRunTime;
  final bool adult;
  final String? firstAirDate;
  final Color? textColor;
  final double? fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    String productionInfoString = "";
    if (firstAirDate != null) {
      DateTime date = DateTime.parse(firstAirDate!);
      productionInfoString += "${date.year}, ";
    } else {
      productionInfoString += "Unknown date, ";
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

    int episodeRunTime = episodesRunTime.isNotEmpty ? episodesRunTime[0] : 0;

    if (episodeRunTime > 0) {
      if (episodeRunTime < 60) {
        productionInfoString += ", $episodeRunTime min";
      } else if (episodeRunTime == 60) {
        productionInfoString += ", ${episodeRunTime ~/ 60} h";
      } else {
        productionInfoString +=
            ", ${episodeRunTime ~/ 60} h ${episodeRunTime % 60} min";
      }
    }

    if (adult) productionInfoString += ", 18+";

    String episodesInfoString =
        "$numberOfSeasons ${numberOfSeasons > 1 ? "seasons" : "season"}, $numberOfEpisodes ${numberOfEpisodes > 1 ? "episodes" : "episode"}";

    return Column(
      children: [
        Text(
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
        ),
        const SizedBox(height: 6),
        Text(
          episodesInfoString,
          maxLines: maxLines,
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .subtitleTextStyle
              .copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor ?? Theme.of(context).colorScheme.secondary,
                fontSize: fontSize,
              ),
        ),
      ],
    );
  }
}
