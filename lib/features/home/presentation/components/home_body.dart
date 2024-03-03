import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/home/presentation/tmdb_media_bloc/tmdb_media_bloc.dart';
import 'package:movies_app/features/home/presentation/components/scrollable_list_template.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  context
                      .read<TMDBMediaBloc>()
                      .add(TMDBMediaPopularMoviesEvent());
                },
                child: const Text(
                  "Popular",
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<TMDBMediaBloc>()
                      .add(TMDBMediaTrendingMoviesEvent());
                },
                child: const Text(
                  "Trending",
                ),
              ),
            ],
          ),
          BlocBuilder<TMDBMediaBloc, TMDBMediaState>(
            builder: (context, state) {
              final popularMovies = context
                  .select((TMDBMediaBloc bloc) => bloc.state.popularMovies);
              if (popularMovies.isEmpty) {
                return const CircularProgressIndicator();
              }
              return CustomScrollList<MovieModel>(
                text: "Popular:",
                models: popularMovies,
                cardWidth: 150,
                listHeight: 250,
              );
            },
          ),
          const SizedBox(height: 15),
          BlocBuilder<TMDBMediaBloc, TMDBMediaState>(
            builder: (context, state) {
              final trendingMovies = context
                  .select((TMDBMediaBloc bloc) => bloc.state.trendingMovies);
              if (trendingMovies.isEmpty) {
                return const CircularProgressIndicator();
              }
              return CustomScrollList<MovieModel>(
                text: "Trending:",
                models: trendingMovies,
                listHeight: 180,
              );
            },
          ),
        ],
      ),
    );
  }
}
