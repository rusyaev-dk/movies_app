import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/features/home/presentation/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(
          HomeLoadAllMediaEvent()), // ..add(TMDBMediaAllMediaEvent()) добавить
      child: Scaffold(
        appBar: AppBar(),
        body: const HomeBody(),
      ),
    );
  }
}
