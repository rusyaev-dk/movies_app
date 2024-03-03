import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/utils/service_functions.dart';
import 'package:movies_app/core/presentation/components/movie_card.dart';

class MoviesListView extends StatelessWidget {
  const MoviesListView({
    super.key,
    required this.movies,
    this.cardWidth = 100,
  });

  final List<MovieModel> movies;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, i) {
        final movie = movies[i];
        return MovieCard(
          width: cardWidth,
          key: ValueKey(movie.id),
          title: movie.title ?? "None",
          voteAverage: movie.voteAverage,
          imageUrl: concatImageUrl(path: movie.posterPath!),
        );
      },
      itemCount: movies.length,
    );
  }
}

class TVSeriesListView extends StatelessWidget {
  const TVSeriesListView({
    super.key,
    required this.tvSeries,
    this.cardWidth = 100,
  });

  final List<TVSeriesModel> tvSeries;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, i) {
        final movie = tvSeries[i];
        return MovieCard(
          width: cardWidth,
          key: ValueKey(movie.id),
          title: movie.name ?? "None",
          voteAverage: movie.voteAverage,
          imageUrl: concatImageUrl(path: movie.posterPath!),
        );
      },
      itemCount: tvSeries.length,
    );
  }
}
