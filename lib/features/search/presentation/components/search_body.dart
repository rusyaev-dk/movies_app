import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/components/search_tile.dart';
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
            final searchModels =
                context.select((SearchBloc bloc) => bloc.state.searchModels);
            if (searchModels.isEmpty) {
              return const CircularProgressIndicator();
            }
            return ListView.separated(
                separatorBuilder: (context, i) => const SizedBox(
                      height: 10,
                    ),
                itemBuilder: (context, i) {
                  final searchModel = searchModels[i];
                  //return Text("Some filn");
                  return SearchTile(model: searchModel);
                },
                itemCount: searchModels.length);
          },
        ),
      ),
    );
  }
}
