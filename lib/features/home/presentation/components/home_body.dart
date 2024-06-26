import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/common/domain/models/tmdb_models.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/router/app_routes.dart';
import 'package:movies_app/features/home/presentation/components/home_failure_widget.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/common/presentation/components/media/media_horizontal_list_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final completer = Completer();
        BlocProvider.of<HomeBloc>(context)
            .add(HomeLoadMediaEvent(completer: completer));
        return completer.future;
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeFailureState) {
            return HomeFailureWidget(failure: state.failure);
          } else if (state is HomeLoadedState) {
            return HomeContent(
              popularMovies: state.popularMovies,
              trendingMovies: state.trendingMovies,
              popularTVSeries: state.popularTVSeries,
              trendingTVSeries: state.trendingTVSeries,
              onTheAirTVSeries: state.onTheAirTVSeries,
              popularPersons: state.popularPersons,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: HomeContent.shimmerLoading(context),
            );
          }
        },
      ),
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, _) {
        return Animate(
          effects: const [FadeEffect()],
          child: Column(
            children: [
              MediaHorizontalListView(
                title: "Popular movies for you",
                onAllButtonPressed: () {
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.popularMovies.asString(),
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
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.popularTVSeries.asString(),
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
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.trendingMovies.asString(),
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
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.onTheAirTVSeries.asString(),
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
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.trendingTVSeries.asString(),
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
                  context.go(
                    "${AppRoutes.home}/${AppRoutes.gridMediaView}",
                    extra: ApiMediaQueryType.popularPersons.asString(),
                  );
                },
                models: widget.popularPersons,
                cardHeight: 210,
                cardWidth: 140,
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
