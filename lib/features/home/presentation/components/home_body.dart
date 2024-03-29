import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
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

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.popularMovies,
    required this.trendingMovies,
    required this.popularTVSeries,
    required this.trendingTVSeries,
  });

  final List<MovieModel> popularMovies;
  final List<MovieModel> trendingMovies;
  final List<TVSeriesModel> popularTVSeries;
  final List<TVSeriesModel> trendingTVSeries;

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
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    return SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () => context
          .read<HomeBloc>()
          .add(HomeRefreshMediaEvent(refreshController: refreshController)),
      child: ListView(
        children: [
          MediaHorizontalListView(
            title: "Popular movies for you",
            models: popularMovies,
            cardHeight: 270,
            cardWidth: 180,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Trending movies",
            models: trendingMovies,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Popular TV series",
            models: popularTVSeries,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Trending TV series",
            models: trendingTVSeries,
            cardHeight: 210,
            cardWidth: 140,
          ),
        ],
      ),
    );
  }
}
