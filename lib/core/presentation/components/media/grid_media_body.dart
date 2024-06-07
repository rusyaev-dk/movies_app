import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/components/media/grid_media_failure_widget.dart';
import 'package:movies_app/core/presentation/components/media/media_card.dart';
import 'package:movies_app/core/presentation/blocs/grid_media_bloc/grid_media_bloc.dart';
import 'package:movies_app/core/routing/app_routes.dart';

class GridMediaBody extends StatelessWidget {
  const GridMediaBody({
    super.key,
    required this.queryType,
  });

  final ApiMediaQueryType queryType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridMediaBloc, GridMediaState>(
      builder: (context, state) {
        switch (state.status) {
          case GridMediaStatus.failure:
            return GridMediaFailureWidget(
              failure: state.failure!,
              queryType: queryType,
            );
          case GridMediaStatus.success:
            final screenWidth = MediaQuery.of(context).size.width;
            final totalPadding = screenWidth - (180 * 2);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: totalPadding / 2),
              child: GridMediaContent(
                models: state.models,
                page: state.page,
                queryType: queryType,
                hasReachedMax: state.hasReachedMax,
              ),
            );
          case GridMediaStatus.initial:
            return GridMediaContent.loading(context);
        }
      },
    );
  }
}

class GridMediaContent extends StatefulWidget {
  const GridMediaContent({
    super.key,
    required this.queryType,
    required this.page,
    required this.models,
    required this.hasReachedMax,
  });

  static Widget loading(BuildContext context) {
    return const RepaintBoundary(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  final ApiMediaQueryType queryType;
  final List<TMDBModel> models;
  final int page;
  final bool hasReachedMax;

  @override
  State<GridMediaContent> createState() => _GridMediaContentState();
}

class _GridMediaContentState extends State<GridMediaContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<GridMediaBloc>().add(
            GridMediaLoadNewMediaEvent(
              queryType: widget.queryType,
              page: widget.page + 1,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final curUri =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final String initialPath;
    if (curUri.contains("home")) {
      initialPath = AppRoutes.home;
    } else {
      initialPath = AppRoutes.watchlist;
    }

    return Animate(
      effects: const [FadeEffect()],
      child: GridView.builder(
        key: ValueKey(widget.queryType),
        controller: _scrollController,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.8 / 3,
          mainAxisSpacing: 18,
          crossAxisSpacing: 25,
        ),
        itemCount: widget.hasReachedMax
            ? widget.models.length
            : widget.models.length + 1,
        itemBuilder: (context, i) {
          if (i >= widget.models.length) {
            return const RepaintBoundary(
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          final model = widget.models[i];

          if (model is MovieModel) {
            return GestureDetector(
              onTap: () {
                context.push(
                  "$initialPath/${AppRoutes.gridMediaView}/${AppRoutes.movieDetails}/${model.id}",
                  extra: [model.id, model.title],
                );
              },
              child: MediaCard(
                key: ValueKey(model.id),
                width: 180,
                voteAverage: model.voteAverage,
                imagePath: model.posterPath,
                cardText: model.title ?? "Unknown movie",
              ),
            );
          } else if (model is TVSeriesModel) {
            return GestureDetector(
              onTap: () {
                context.push(
                  "$initialPath/${AppRoutes.gridMediaView}/${AppRoutes.tvSeriesDetails}/${model.id}",
                  extra: [model.id, model.name],
                );
              },
              child: MediaCard(
                key: ValueKey(model.id),
                width: 180,
                voteAverage: model.voteAverage,
                imagePath: model.posterPath,
                cardText: model.name ?? "Unknown tv series",
              ),
            );
          } else if (model is PersonModel) {
            return GestureDetector(
              onTap: () {
                context.push(
                  "$initialPath/${AppRoutes.gridMediaView}/${AppRoutes.personDetails}/${model.id}",
                  extra: [model.id, model.name],
                );
              },
              child: MediaCard(
                key: ValueKey(model.id),
                width: 180,
                imagePath: model.profilePath,
                cardText: model.name ?? "Unknown person",
              ),
            );
          } else {
            return const MediaCard(
              width: 180,
              voteAverage: 0,
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
