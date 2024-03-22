import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/core/presentation/blocs/person_details_bloc/person_details_bloc.dart';
import 'package:movies_app/core/presentation/blocs/tv_series_bloc/tv_series_details_bloc.dart';
import 'package:movies_app/core/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/core/presentation/screens/person_details_screen.dart';
import 'package:movies_app/core/presentation/screens/tv_series_details_screen.dart';

class MediaDetailsSwitcherScreen extends StatelessWidget {
  const MediaDetailsSwitcherScreen({
    super.key,
    required this.mediaType,
    required this.appBarTitle,
    required this.mediaId,
  });

  final TMDBMediaType mediaType;
  final String appBarTitle;
  final int mediaId;

  @override
  Widget build(BuildContext context) {
    switch (mediaType) {
      case TMDBMediaType.movie:
        return BlocProvider(
          create: (context) => MovieDetailsBloc(
            mediaRepository: RepositoryProvider.of<MediaRepository>(context),
          )..add(MovieDetailsLoadDetailsEvent(movieId: mediaId)),
          child: Scaffold(
            body: MovieDetailsScreen(appBarTitle: appBarTitle),
          ),
        );
      case TMDBMediaType.tv:
        return BlocProvider(
          create: (context) => TvSeriesDetailsBloc(
            mediaRepository: RepositoryProvider.of<MediaRepository>(context),
          )..add(TVSeriesDetailsLoadDetailsEvent(tvSeriesId: mediaId)),
          child: Scaffold(
            body: TVSeriesDetailsScreen(appBarTitle: appBarTitle),
          ),
        );
      case TMDBMediaType.person:
        return BlocProvider(
          create: (context) => PersonDetailsBloc(
            mediaRepository: RepositoryProvider.of<MediaRepository>(context),
          )..add(PersonDetailsLoadDetailsEvent(personId: mediaId)),
          child: Scaffold(
            body: PersonDetailsScreen(appBarTitle: appBarTitle),
          ),
        );
    }
  }
}
