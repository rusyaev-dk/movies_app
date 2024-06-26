import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:movies_app/features/media_details/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_appbar.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_body.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieDetailsBloc(
            sessionDataRepository: GetIt.I<SessionDataRepository>(),
            accountRepository: GetIt.I<AccountRepository>(),
            mediaRepository: GetIt.I<MediaRepository>(),
          )..add(MovieDetailsLoadDetailsEvent(movieId: movieId)),
        ),
        BlocProvider(
          create: (context) => MediaDetailsAppbarCubit(),
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MovieDetailsAppBar(appBarTitle: appBarTitle),
        body: const MovieDetailsBody(),
      ),
    );
  }
}
