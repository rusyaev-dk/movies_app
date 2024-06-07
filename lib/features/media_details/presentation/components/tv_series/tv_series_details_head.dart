import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/components/media_genres_text.dart';
import 'package:movies_app/features/media_details/presentation/components/media_title_text.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_production_info.dart';

class TVSeriesDetailsHead extends StatelessWidget {
  const TVSeriesDetailsHead({
    super.key,
    required this.tvSeries,
  });

  final TVSeriesModel tvSeries;

  static Widget shimmerLoading() {
    return Column(
      children: [
        Container(
          height: 18,
          width: 150,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Container(
          height: 16,
          width: 120,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Container(
          height: 16,
          width: 120,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Container(
          height: 16,
          width: 120,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).extension<ThemeColors>()!.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: MediaTitleText(
              voteAverage: tvSeries.voteAverage ?? 0,
              title: tvSeries.name ?? "Unknown title",
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Column(
              children: [
                MediaGenresText(
                  mediaGenres: tvSeries.genres == null
                      ? []
                      : tvSeries.genres!
                          .map((mediaGenre) => mediaGenre.name ?? "")
                          .toList(),
                  centerText: true,
                ),
                const SizedBox(height: 6),
                TVSeriesProductionInfo(
                  firstAirDate: tvSeries.firstAirDate,
                  productionCountries: tvSeries.productionCountries ?? [],
                  numberOfSeasons: tvSeries.numberOfSeasons ?? 0,
                  numberOfEpisodes: tvSeries.numberOfEpisodes ?? 0,
                  episodesRunTime: tvSeries.episodeRunTime ?? [],
                  adult: tvSeries.adult ?? false,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
