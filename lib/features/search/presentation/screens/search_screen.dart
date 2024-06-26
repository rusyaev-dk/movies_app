import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/persistence/storage/shared_prefs_storage.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:movies_app/features/search/presentation/components/search_appbar.dart';
import 'package:movies_app/features/search/presentation/components/search_body.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        networkCubit: BlocProvider.of<NetworkCubit>(context),
        mediaRepository: GetIt.I<MediaRepository>(),
        keyValueStorage: GetIt.I<SharedPrefsStorage>(),
        searchFiltersRepository: GetIt.I<SearchFiltersRepository>(),
      ),
      child: const Scaffold(
        appBar: SearchAppBar(),
        body: SearchBody(),
      ),
    );
  }
}
