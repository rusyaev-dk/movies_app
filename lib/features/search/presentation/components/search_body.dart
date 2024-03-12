import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/search/presentation/components/search_list.dart';
import 'package:movies_app/features/search/presentation/search_bloc/search_bloc.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            final List<TMDBModel> searchModels = state.searchModels;
            if (searchModels.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SearchList(models: searchModels);
          },
        ),
      ),
    );
  }
}
