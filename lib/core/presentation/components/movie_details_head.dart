import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/media_genres_text.dart';
import 'package:movies_app/core/presentation/components/movie_production_info.dart';
import 'package:movies_app/core/presentation/formatters/media_vote_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';

class MovieDetailsHead extends StatelessWidget {
  const MovieDetailsHead({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final double roundedVoteAverage =
        ApiMediaVoteFormatter.formatVoteAverage(voteAverage: movie.voteAverage);

    final Color voteColor = ApiMediaVoteFormatter.getVoteColor(
      context: context,
      voteAverage: roundedVoteAverage,
      isRounded: true,
    );

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$roundedVoteAverage",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle
                    .copyWith(color: voteColor, fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                movie.title ?? "Unknown movie",
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Column(
              children: [
                const SizedBox(height: 6),
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
