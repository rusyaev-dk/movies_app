import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/components/search_additional.dart';
import 'package:movies_app/features/search/presentation/components/search_failure_widget.dart';
import 'package:movies_app/features/search/presentation/components/search_list.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchFailureState) {
          return SearchFailureWidget(
            failure: state.failure,
            query: state.query,
          );
        } else if (state is SearchLoadingState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchList.shimmerLoading(),
          );
        } else if (state is SearchLoadedState) {
          if (state.searchModels.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: NothingFoundWidget(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchList(models: state.searchModels),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LetsFindSomethingWidget(),
          );
        }
      },
    );
  }
}
