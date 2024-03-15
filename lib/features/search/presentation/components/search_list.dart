import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/api_image_formatter.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/service_functions.dart';

class SearchList extends StatelessWidget {
  const SearchList({super.key, required this.models});

  final List<TMDBModel> models;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, i) => const SizedBox(height: 20),
      itemBuilder: (context, i) {
        final model = models[i];
        switch (model) {
          case MovieModel():
            return SearchListTile(
              imagePath: model.posterPath,
              title: model.title ?? "None",
              subtitle: "${model.originalTitle}, ${model.releaseDate}",
              voteAverage: model.voteAverage ?? 0,
              genreIds: model.genreIds ?? [],
            );
          case TVSeriesModel():
            return SearchListTile(
              imagePath: model.posterPath,
              title: model.name ?? "None",
              subtitle:
                  "${model.originalName}, ${model.firstAirDate} - ${model.lastAirDate}",
              voteAverage: model.voteAverage ?? 0,
              genreIds: model.genreIds ?? [],
            );
          case PersonModel():
            return SearchListTile(
              imagePath: model.profilePath,
              title: model.name ?? "Unknonwn",
              subtitle: "${model.originalName} id: ${model.id}",
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

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget =
        ApiImageFormatter.formatImageWidget(imagePath: imagePath);
    Widget? voteWidget;

    if (voteAverage != null) {
      final double roundedVoteAverage =
          formatVoteAverage(voteAverage: voteAverage!);

      final Color voteColor = getVoteColor(
        context: context,
        voteAverage: roundedVoteAverage,
        isRounded: true,
      );

      voteWidget = Expanded(
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
    }

    Widget? genresTextWidget;
    if (genreIds != null && genreIds!.isNotEmpty) {
      final String genresString = genreIdsToString(genreIds: genreIds!);
      genresTextWidget = Text(
        genresString,
        maxLines: 3,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .subtitleTextStyle
            .copyWith(
              overflow: TextOverflow.ellipsis,
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    }

    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            width: 80,
            child: imageWidget,
          ),
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
                  if (genresTextWidget != null) genresTextWidget,
                ],
              ),
            ),
          ),
          if (voteWidget != null) voteWidget,
        ],
      ),
    );
  }
}
