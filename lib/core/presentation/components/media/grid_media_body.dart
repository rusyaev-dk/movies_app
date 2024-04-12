import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/components/media/media_card.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/presentation/blocs/grid_media_bloc/grid_media_bloc.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

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
            switch (state.failure!.type) {
              case (ApiClientExceptionType.sessionExpired):
                return FailureWidget(
                    failure: state.failure!,
                    buttonText: "Login",
                    icon: Icons.exit_to_app_outlined,
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                      context.go(AppRoutes.screenLoader);
                    });
              case (ApiClientExceptionType.network):
                return FailureWidget(
                  failure: state.failure!,
                  buttonText: "Update",
                  icon: Icons.wifi_off,
                  onPressed: () => context
                      .read<GridMediaBloc>()
                      .add(GridMediaLoadNewMediaEvent(queryType: queryType)),
                );
              default:
                return FailureWidget(
                  failure: state.failure!,
                  onPressed: () => context
                      .read<GridMediaBloc>()
                      .add(GridMediaLoadNewMediaEvent(queryType: queryType)),
                );
            }
          case GridMediaStatus.success:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
    return const Center(
      child: CircularProgressIndicator(),
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
    return GridView.builder(
      key: ValueKey(widget.queryType),
      controller: _scrollController,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 25,
        mainAxisSpacing: 15,
      ),
      itemCount: widget.hasReachedMax
          ? widget.models.length
          : widget.models.length + 1,
      itemBuilder: (context, i) {
        if (i >= widget.models.length) {
          return const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(),
            ),
          );
        }
        final model = widget.models[i];
        if (model is MovieModel) {
          return GestureDetector(
            onTap: () {
              context
                  .push("/home/movie_details", extra: [model.id, model.title]);
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
              context.push("/home/tv_series_details",
                  extra: [model.id, model.name]);
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
              final currentRoute = GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString();

              if (currentRoute ==
                  "${AppRoutes.home}/${AppRoutes.movieDetails}") {
                context.push(
                    "${AppRoutes.home}/${AppRoutes.movieDetails}/${AppRoutes.personDetails}",
                    extra: [model.id, model.name]);
              } else if (currentRoute ==
                  "${AppRoutes.home}/${AppRoutes.tvSeriesDetails}") {
                context.push(
                    "${AppRoutes.home}/${AppRoutes.tvSeriesDetails}/${AppRoutes.personDetails}",
                    extra: [model.id, model.name]);
              } else if (currentRoute ==
                  "${AppRoutes.search}/${AppRoutes.movieDetails}") {
                context.push(
                    "${AppRoutes.search}/${AppRoutes.movieDetails}/${AppRoutes.personDetails}",
                    extra: [model.id, model.name]);
              } else {
                context.push(
                    "${AppRoutes.search}/${AppRoutes.tvSeriesDetails}/${AppRoutes.personDetails}",
                    extra: [model.id, model.name]);
              }
            },
            child: MediaCard(
              key: ValueKey(model.id),
              width: 180,
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
          return const MediaCard(
            width: 180,
            voteAverage: 0,
          );
        }
      },
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
