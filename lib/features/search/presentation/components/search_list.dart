import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/search/presentation/components/search_list_tile.dart';

class SearchList extends StatelessWidget {
  const SearchList({super.key, required this.models});

  final List<TMDBModel> models;

  static Widget shimmerLoading() {
    return ListView.separated(
      separatorBuilder: (context, i) => const SizedBox(height: 20),
      itemBuilder: (context, i) {
        return SearchListTile.shimmerLoading(context);
      },
      itemCount: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, i) => const SizedBox(height: 20),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, i) {
        final model = models[i];
        if (model is MovieModel) {
          return InkWell(
            onTap: () {
              context.push(
                "${AppRoutes.search}/${AppRoutes.movieDetails}/${model.id}",
                extra: [model.id, model.title],
              );
            },
            child: SearchListTile(
              imagePath: model.posterPath,
              title: model.title ?? "Unknown",
              originalTitle: model.originalTitle ?? "Unknown",
              firstAirDate: model.releaseDate,
              voteAverage: model.voteAverage ?? 0,
              genreIds: model.genreIds ?? [],
            ),
          );
        } else if (model is TVSeriesModel) {
          return InkWell(
            onTap: () {
              context.push(
                "${AppRoutes.search}/${AppRoutes.tvSeriesDetails}/${model.id}",
                extra: [model.id, model.name],
              );
            },
            child: SearchListTile(
              imagePath: model.posterPath,
              title: model.name ?? "Unknown",
              originalTitle: model.originalName ?? "Unknown",
              firstAirDate: model.firstAirDate,
              lastAirDate: model.lastAirDate,
              voteAverage: model.voteAverage ?? 0,
              genreIds: model.genreIds ?? [],
            ),
          );
        } else if (model is PersonModel) {
          return InkWell(
            onTap: () {
              context.push(
                "${AppRoutes.search}/${AppRoutes.personDetails}/${model.id}",
                extra: [model.id, model.name],
              );
            },
            child: SearchListTile(
              imagePath: model.profilePath,
              title: model.name ?? "Unknonwn",
              originalTitle: model.originalName ?? "Unknown",
              isPerson: true,
            ),
          );
        } else {
          return null;
        }
      },
      itemCount: models.length,
    );
  }
}
