import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/core/presentation/media_details_bloc/media_details_bloc.dart';
import 'package:movies_app/core/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/core/presentation/screens/person_details_screen.dart';
import 'package:movies_app/core/presentation/screens/tvseries_details_screen.dart';

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
    Widget screen;
    if (mediaType == TMDBMediaType.movie) {
      screen = MovieDetailsScreen(appBarTitle: appBarTitle);
    } else if (mediaType == TMDBMediaType.tv) {
      screen = const TVSeriesDetailsScreen();
    } else {
      screen = const PersonDetailsScreen();
    }

    return BlocProvider(
      create: (context) => MediaDetailsBloc(
        networkCubit: RepositoryProvider.of<NetworkCubit>(context),
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(
          MediaDetailsLoadDetailsEvent(mediaType: mediaType, mediaId: mediaId)),
      child: Scaffold(
        body: screen,
      ),
    );
  }
}
