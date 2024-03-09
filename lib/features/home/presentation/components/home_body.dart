import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/home/presentation/tmdb_media_bloc/tmdb_media_bloc.dart';
import 'package:movies_app/features/home/presentation/components/scrollable_list_template.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: BlocBuilder<TMDBMediaBloc, TMDBMediaState>(
          builder: (context, state) {
            if (state.isLoading) {
              return ListView(
                children: const [
                  CustomMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 270,
                    cardWidth: 180,
                  ),
                  SizedBox(height: 20),
                  CustomMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 210,
                    cardWidth: 140,
                  ),
                  SizedBox(height: 20),
                  CustomMediaScrollList(
                    title: "",
                    models: [],
                    cardHeight: 210,
                    cardWidth: 140,
                  ),
                  SizedBox(height: 20),
                  CustomMediaScrollList(
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
                CustomMediaScrollList(
                  title: "Popular movies for you",
                  models: popularMovies,
                  cardHeight: 270,
                  cardWidth: 180,
                ),
                const SizedBox(height: 20),
                CustomMediaScrollList(
                  title: "Trending movies",
                  models: trendingMovies,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                CustomMediaScrollList(
                  title: "Popular TV series:",
                  models: popularTVSeries,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                CustomMediaScrollList(
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
