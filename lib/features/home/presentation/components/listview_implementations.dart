import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/movie_card.dart';

class MediaListView extends StatelessWidget {
  const MediaListView({
    super.key,
    required this.models,
    this.cardWidth = 100,
  });

  final List<TMDBModel> models;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, i) {
        final model = models[i];
        if (model is MovieModel) {
          return MediaCard(
            key: ValueKey(model.id),
            width: cardWidth,
            voteAverage: model.voteAverage,
            imageUrl: model.posterPath,
          );
        } else if (model is TVSeriesModel) {
          return MediaCard(
            key: ValueKey(model.id),
            width: cardWidth,
            voteAverage: model.voteAverage,
            imageUrl: model.posterPath,
          );
        } else {
          return MediaCard(
            width: cardWidth,
            voteAverage: 0,
          );
        }
      },
      itemCount: models.length,
    );
  }
}
