import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeFailureState) {
          switch (state.failure.type) {
            case (ApiClientExceptionType.sessionExpired):
              return FailureWidget(
                  failure: state.failure,
                  buttonText: "Login",
                  icon: Icons.exit_to_app_outlined,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                    context.go(AppRoutes.screenLoader);
                  });
            case (ApiClientExceptionType.network):
              return FailureWidget(
                failure: state.failure,
                buttonText: "Update",
                icon: Icons.wifi_off,
                onPressed: () =>
                    context.read<HomeBloc>().add(HomeLoadMediaEvent()),
              );
            default:
              return FailureWidget(
                failure: state.failure,
                onPressed: () =>
                    context.read<HomeBloc>().add(HomeLoadMediaEvent()),
              );
          }
        }

        if (state is HomeLoadingState) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: HomeContent.shimmerLoading(context),
          );
        }

        if (state is HomeLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: HomeContent(
              popularMovies: state.popularMovies,
              trendingMovies: state.trendingMovies,
              popularTVSeries: state.popularTVSeries,
              trendingTVSeries: state.trendingTVSeries,
              onTheAirTVSeries: state.onTheAirTVSeries,
              popularPersons: state.popularPersons,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: HomeContent.shimmerLoading(context),
        );
      },
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
    required this.popularMovies,
    required this.trendingMovies,
    required this.popularTVSeries,
    required this.trendingTVSeries,
    required this.onTheAirTVSeries,
    required this.popularPersons,
  });

  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;
  final List<TVSeriesModel> onTheAirTVSeries;
  final List<PersonModel> popularPersons;

  static Widget shimmerLoading(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 270, cardWidth: 180),
        const SizedBox(height: 20),
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 210, cardWidth: 140),
        const SizedBox(height: 20),
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 210, cardWidth: 140),
      ],
    );
  }

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: () => context
          .read<HomeBloc>()
          .add(HomeRefreshMediaEvent(refreshController: _refreshController)),
      child: ListView(
        children: [
          MediaHorizontalListView(
            title: "Popular movies for you",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.popularMovies,
              );
            },
            models: widget.popularMovies,
            cardHeight: 270,
            cardWidth: 180,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Popular TV series",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.popularTVSeries,
              );
            },
            models: widget.popularTVSeries,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Trending movies",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.trendingMovies,
              );
            },
            models: widget.trendingMovies,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "On the air",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.onTheAirTVSeries,
              );
            },
            models: widget.onTheAirTVSeries,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Trending TV series",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.trendingTVSeries,
              );
            },
            models: widget.trendingTVSeries,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Popular persons",
            onAllButtonPressed: () {
              context.push(
                "${AppRoutes.home}/${AppRoutes.allMediaView}",
                extra: ApiMediaQueryType.popularPersons,
              );
            },
            models: widget.popularPersons,
            cardHeight: 210,
            cardWidth: 140,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
