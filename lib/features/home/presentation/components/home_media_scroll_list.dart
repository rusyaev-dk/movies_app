import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/movie_card.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class HomeMediaScrollList extends StatelessWidget {
  const HomeMediaScrollList({
    super.key,
    this.models = const [],
    this.title = "",
    this.cardWidth = 100,
    this.cardHeight = 150,
  });

  final List<TMDBModel> models;
  final String title;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    Widget listView = const Placeholder(); // ВРЕМЕННО

    listView = MediaListView(
      models: models,
      cardWidth: cardWidth,
    );

    if (title.isEmpty) {
      return Shimmer(
        direction: ShimmerDirection.ltr,
        gradient:
            Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTitle(
              title: title,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: listView,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTitle(
          title: title,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: cardHeight,
          width: double.infinity,
          child: listView,
        ),
      ],
    );
  }
}

class ListTitle extends StatelessWidget {
  const ListTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    List<Widget> shimmerChildren = [
      Container(
        height: 20,
        width: 100,
        color: Colors.white,
      ),
      const Spacer(),
      Container(
        height: 20,
        width: 40,
        color: Colors.white,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: title.isEmpty
            ? shimmerChildren
            : [
                Text(
                  title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingTextStyle,
                ),
                const Spacer(),
                Text(
                  "All",
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingTextStyle
                      .copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
      ),
    );
  }
}

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
    if (models.isEmpty) {
      return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              width: cardWidth,
              color: Colors.white,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(width: 10);
          },
          itemCount: 5);
    }

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
            imagePath: model.posterPath,
            cardText: model.title ?? "None",
          );
        } else if (model is TVSeriesModel) {
          return MediaCard(
            key: ValueKey(model.id),
            width: cardWidth,
            voteAverage: model.voteAverage,
            imagePath: model.posterPath,
            cardText: model.name ?? "None",
          );
        } else if (model is PersonModel) {
          return MediaCard(
            key: ValueKey(model.id),
            width: cardWidth,
            imagePath: model.profilePath,
            cardText: model.name ?? "None",
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
