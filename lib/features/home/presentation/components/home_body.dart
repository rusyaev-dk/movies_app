import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/presentation/components/exception_widget.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/features/home/presentation/components/home_media_scroll_list.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.exception != null) {
              if (state.exception!.type ==
                  ApiClientExceptionType.sessionExpired) {
                context.go(AppRoutes.auth);
              }
              return ExceptionWidget(
                exceptionText: state.exception!.getExceptionInfo(),
                buttonText: "Update",
                icon: Icons.wifi_off,
                onPressed: () =>
                    context.read<HomeBloc>().add(HomeLoadAllMediaEvent()),
              );
            }

            if (state.isLoading) {
              return ListView(
                children: const [
                  HomeMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 270,
                    cardWidth: 180,
                  ),
                  SizedBox(height: 20),
                  HomeMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 210,
                    cardWidth: 140,
                  ),
                  SizedBox(height: 20),
                  HomeMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 210,
                    cardWidth: 140,
                  ),
                  SizedBox(height: 20),
                  HomeMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 210,
                    cardWidth: 140,
                  ),
                ],
              );
            }

            final List<MovieModel> popularMovies = state.popularMovies;
            final List<MovieModel> trendingMovies = state.trendingMovies;
            final List<TVSeriesModel> popularTVSeries = state.popularTVSeries;
            final List<TVSeriesModel> trendingTVSeries = state.trendingTVSeries;

            return ListView(
              children: [
                HomeMediaScrollList(
                  title: "Popular movies for you",
                  models: popularMovies,
                  cardHeight: 270,
                  cardWidth: 180,
                ),
                const SizedBox(height: 20),
                HomeMediaScrollList(
                  title: "Trending movies",
                  models: trendingMovies,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                HomeMediaScrollList(
                  title: "Popular TV series:",
                  models: popularTVSeries,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                HomeMediaScrollList(
                  title: "Trending TV series:",
                  models: trendingTVSeries,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
