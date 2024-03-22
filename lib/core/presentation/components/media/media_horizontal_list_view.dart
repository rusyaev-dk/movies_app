import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/media/media_card.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class MediaHorizontalListView extends StatelessWidget {
  const MediaHorizontalListView({
    super.key,
    this.models = const [],
    this.title,
    this.withAllButton = false,
    this.cardWidth = 100,
    this.cardHeight = 150,
  });

  final List<TMDBModel> models;
  final String? title;
  final bool withAllButton;
  final double cardWidth;
  final double cardHeight;

  static Widget shimmerLoading(
    BuildContext context, {
    bool withTitle = true,
    required double cardHeight,
    required double cardWidth,
  }) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withTitle) ListTitle.shimmerLoading(),
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
            withAllButton: withAllButton,
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
    this.withAllButton = true,
  });

  final String title;
  final bool withAllButton;

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
          if (withAllButton) const Spacer(),
          if (withAllButton)
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
            onTap: () => context.go("/home/media_details",
                extra: [TMDBMediaType.movie, model.title, model.id]),
            child: MediaCard(
              key: ValueKey(model.id),
              width: cardWidth,
              voteAverage: model.voteAverage,
              imagePath: model.posterPath,
              cardText: model.title ?? "Unknown movie",
            ),
          );
        } else if (model is TVSeriesModel) {
          return GestureDetector(
            onTap: () => context.go("/home/media_details",
                extra: [TMDBMediaType.tv, model.name, model.id]),
            child: MediaCard(
              key: ValueKey(model.id),
              width: cardWidth,
              voteAverage: model.voteAverage,
              imagePath: model.posterPath,
              cardText: model.name ?? "Unknown tv series",
            ),
          );
        } else if (model is PersonModel) {
          return GestureDetector(
            onTap: () {
              final currentRoute = GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString();

              if (currentRoute == "/home/media_details") {
                context.go("/home/media_details/person_details",
                    extra: [TMDBMediaType.person, model.name, model.id]);
              } else if (currentRoute == "/search/media_details") {
                context.go("/search/media_details/person_details",
                    extra: [TMDBMediaType.person, model.name, model.id]);
              }
            },
            child: MediaCard(
              key: ValueKey(model.id),
              width: cardWidth,
              imagePath: model.profilePath,
              cardText: model.name ?? "Unknown person",
            ),
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
