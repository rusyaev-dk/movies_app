import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/home/presentation/components/home_appbar.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/features/home/presentation/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        networkCubit: BlocProvider.of<NetworkCubit>(context),
        mediaRepository: GetIt.I<MediaRepository>(),
      )..add(HomeLoadMediaEvent()), // ..add(HomeLoadAllMediaEvent()) добавить
      child: const Scaffold(
        appBar: HomeAppBar(),
        body: HomeBody(),
      ),
    );
  }
}
