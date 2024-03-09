import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/tmdb_media_repository.dart';
import 'package:movies_app/features/home/presentation/tmdb_media_bloc/tmdb_media_bloc.dart';
import 'package:movies_app/features/home/presentation/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TMDBMediaBloc(
        tmdbRepository: RepositoryProvider.of<TMDBMediaRepository>(context),
      )..add(TMDBMediaAllMediaEvent()),
      child: Scaffold(
        appBar: AppBar(),
        body: const HomeBody(),
      ),
    );
  }
}
