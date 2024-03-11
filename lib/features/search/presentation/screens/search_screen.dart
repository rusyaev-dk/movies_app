import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/features/search/presentation/components/search_appbar.dart';
import 'package:movies_app/features/search/presentation/components/search_body.dart';
import 'package:movies_app/features/search/presentation/search_bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      ),
      child: const Scaffold(
        appBar: CustomSearchAppBar(),
        body: SearchBody(),
      ),
    );
  }
}
