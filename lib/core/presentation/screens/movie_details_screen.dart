import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/core/presentation/components/movie/movie_details_body.dart';

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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.star_border))
          ],
        ),
        body: const MovieDetailsBody(),
      ),
    );
  }
}
