import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/movie_card.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class MediaHorizontalScrollList extends StatelessWidget {
  const MediaHorizontalScrollList({
    super.key,
    this.models = const [],
    this.title,
    this.cardWidth = 100,
    this.cardHeight = 150,
  });

  final List<TMDBModel> models;
  final String? title;
  final double cardWidth;
  final double cardHeight;

  static Widget shimmerLoading(
    BuildContext context, {
    required double cardHeight,
    required double cardWidth,
  }) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTitle.shimmerLoading(),
          const SizedBox(height: 10),
          SizedBox(
            height: cardHeight,
            width: double.infinity,
            child: MediaListView.shimmerLoading(cardWidth: cardWidth),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget listView = const Placeholder(); // ВРЕМЕННО

    listView = MediaListView(
      models: models,
      cardWidth: cardWidth,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          ListTitle(
            title: title!,
          ),
        const SizedBox(height: 10),
        SizedBox(
          height: cardHeight + 30,
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

  static Widget shimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
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

  static Widget shimmerLoading({required double cardWidth}) {
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
          return GestureDetector(
            onTap: () => context.go(AppRoutes.mediaDetails,
                extra: [TMDBMediaType.movie, model.title, model.id]),
            child: MediaCard(
              key: ValueKey(model.id),
              width: cardWidth,
              voteAverage: model.voteAverage,
              imagePath: model.posterPath,
              cardText: model.title ?? "None",
            ),
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
