import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      .add(TMDBMediaAllMediaEvent());
                },
                child: const Text(
                  "Load content",
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
              return CustomMediaScrollList(
                title: "Popular movies for you",
                models: popularMovies,
                cardHeight: 270,
                cardWidth: 180,
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<TMDBMediaBloc, TMDBMediaState>(
            builder: (context, state) {
              final trendingMovies = context
                  .select((TMDBMediaBloc bloc) => bloc.state.trendingMovies);
              if (trendingMovies.isEmpty) {
                return const CircularProgressIndicator();
              }
              return CustomMediaScrollList(
                title: "Trending movies",
                models: trendingMovies,
                cardHeight: 210,
                cardWidth: 140,
              );
            },
          ),
        ],
      ),
    );
  }
}
