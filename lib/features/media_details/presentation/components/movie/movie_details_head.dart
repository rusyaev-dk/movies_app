import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/components/media_genres_text.dart';
import 'package:movies_app/features/media_details/presentation/components/media_title_text.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_production_info.dart';

class MovieDetailsHead extends StatelessWidget {
  const MovieDetailsHead({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

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
          MediaTitleText(
            voteAverage: movie.voteAverage ?? 0,
            title: movie.title ?? "Unknown title",
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Column(
              children: [
                MediaGenresText(
                  mediaGenres: movie.genres == null
                      ? []
                      : movie.genres!
                          .map((mediaGenre) => mediaGenre.name ?? "")
                          .toList(),
                  centerText: true,
                ),
                const SizedBox(height: 6),
                MovieProductionInfo(
                  releaseDate: movie.releaseDate ?? "Unknown date",
                  productionCountries: movie.productionCountries ?? [],
                  runtime: movie.runtime ?? 0,
                  adult: movie.adult ?? false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
