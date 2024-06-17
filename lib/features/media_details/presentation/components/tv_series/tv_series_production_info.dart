import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/utils/formatters/data_formatter.dart';
import 'package:movies_app/uikit/colors/app_color_sheme.dart';
import 'package:movies_app/uikit/text/app_text_sheme.dart';

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
    if (DataFormatter.isCorrectDateString(firstAirDate)) {
      productionInfoString +=
          "${DataFormatter.getYearFromDate(firstAirDate!)}, ";
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
          style: AppTextScheme.of(context).label.copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor ?? AppColorScheme.of(context).secondary,
                fontSize: fontSize,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          episodesInfoString,
          maxLines: maxLines,
          style: AppTextScheme.of(context).label.copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor ?? AppColorScheme.of(context).secondary,
                fontSize: fontSize,
              ),
        ),
      ],
    );
  }
}
