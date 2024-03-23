import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/features/media_details/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_appbar.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_body.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.appBarTitle,
  });

  final int movieId;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsBloc(
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(MovieDetailsLoadDetailsEvent(movieId: movieId)),
      child: const Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MovieDetailsAppBar(),
        body: MovieDetailsBody(),
      ),
    );
  }
}
