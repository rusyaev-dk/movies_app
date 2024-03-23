import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/media_details/presentation/components/media_genres_text.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/formatters/media_genres_formatter.dart';
import 'package:movies_app/core/presentation/formatters/media_vote_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

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
      itemBuilder: (context, i) {
        final model = models[i];
        switch (model) {
          case MovieModel():
            return GestureDetector(
              onTap: () => context.go(
                  "${AppRoutes.search}/${AppRoutes.movieDetails}",
                  extra: [model.id, model.title]),
              child: SearchListTile(
                imagePath: model.posterPath,
                title: model.title ?? "None",
                subtitle: "${model.originalTitle}, ${model.releaseDate}",
                voteAverage: model.voteAverage ?? 0,
                genreIds: model.genreIds ?? [],
              ),
            );
          case TVSeriesModel():
            return GestureDetector(
              onTap: () => context.go(
                  "${AppRoutes.search}/${AppRoutes.tvSeriesDetails}",
                  extra: [model.id, model.name]),
              child: SearchListTile(
                imagePath: model.posterPath,
                title: model.name ?? "None",
                subtitle:
                    "${model.originalName}, ${model.firstAirDate} - ${model.lastAirDate}",
                voteAverage: model.voteAverage ?? 0,
                genreIds: model.genreIds ?? [],
              ),
            );
          case PersonModel():
            return GestureDetector(
              onTap: () => context.go(
                  "${AppRoutes.search}/${AppRoutes.personDetails}",
                  extra: [model.id, model.name]),
              child: SearchListTile(
                imagePath: model.profilePath,
                title: model.name ?? "Unknonwn",
                subtitle: "${model.originalName} id: ${model.id}",
              ),
            );
          default:
            return null;
        }
      },
      itemCount: models.length,
    );
  }
}

class SearchListTile extends StatelessWidget {
  const SearchListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.genreIds,
    this.voteAverage,
  });

  final String title;
  final String subtitle;
  final String? imagePath;
  final List<dynamic>? genreIds;
  final double? voteAverage;

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 80,
              color: Colors.white,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 20,
                width: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: imagePath, width: 80, height: 120);

    final double roundedVoteAverage =
        ApiMediaVoteFormatter.formatVoteAverage(voteAverage: voteAverage);

    final Color voteColor = ApiMediaVoteFormatter.getVoteColor(
      context: context,
      voteAverage: roundedVoteAverage,
      isRounded: true,
    );

    Widget voteWidget = Expanded(
      flex: 1,
      child: Center(
        child: Text(
          "$roundedVoteAverage",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .headingTextStyle
              .copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
                color: voteColor,
              ),
        ),
      ),
    );

    Widget genresTextWidget = MediaGenresText(
      mediaGenres:
          ApiMediaGenresFormatter.genreIdsToList(genreIds: genreIds ?? []),
    );

    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imageWidget,
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .headingTextStyle
                        .copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 3,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .subtitleTextStyle
                        .copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  genresTextWidget,
                ],
              ),
            ),
          ),
          voteWidget,
        ],
      ),
    );
  }
}
