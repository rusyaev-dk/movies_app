import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/media/media_card.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class MediaHorizontalListView extends StatelessWidget {
  const MediaHorizontalListView({
    super.key,
    this.models = const [],
    this.title,
    this.withAllButton = true,
    this.cardWidth = 100,
    this.cardHeight = 150,
    this.onAllButtonPressed,
  });

  final List<TMDBModel> models;
  final String? title;
  final bool withAllButton;
  final void Function()? onAllButtonPressed;
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
    Widget listView = MediaListView(
      models: models,
      cardWidth: cardWidth,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          ListTitle(
            withAllButton: withAllButton,
            onAllButtonPressed: onAllButtonPressed,
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
    this.onAllButtonPressed,
  });

  final String title;
  final bool withAllButton;
  final void Function()? onAllButtonPressed;

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
            InkWell(
              onTap: onAllButtonPressed,
              child: Text(
                "All",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle
                    .copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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

        final curUri =
            GoRouter.of(context).routeInformationProvider.value.uri.toString();
        final String initialPath;
        if (curUri.contains("home")) {
          initialPath = AppRoutes.home;
        } else if (curUri.contains("search")) {
          initialPath = AppRoutes.search;
        } else {
          initialPath = AppRoutes.watchlist;
        }

        if (model is MovieModel) {
          return GestureDetector(
            onTap: () {
              context.push(
                "$initialPath/${AppRoutes.movieDetails}/${(model.id ?? 0).toString()}",
                extra: [model.id, model.title],
              );
            },
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
            onTap: () {
              context.push(
                "$initialPath/${AppRoutes.tvSeriesDetails}/${(model.id ?? 0).toString()}",
                extra: [model.id, model.name],
              );
            },
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
              context.push(
                "$initialPath/${AppRoutes.personDetails}/${(model.id ?? 0).toString()}",
                extra: [model.id, model.name],
              );
            },
            child: MediaCard(
              key: ValueKey(model.id),
              width: cardWidth,
              imagePath: model.profilePath,
              cardText: model.name ?? "Unknown person",
            ),
          );
        } else if (model is MediaImageModel) {
          return ApiImageFormatter.formatImageWidgetWithAspectRatio(
            context,
            imagePath: model.filePath,
            aspectRatio: model.aspectRatio ?? 1.778,
            width: 240,
            height: 180,
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
