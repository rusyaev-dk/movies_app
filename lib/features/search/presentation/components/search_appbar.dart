import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/components/filters_bottom_sheet.dart';
import 'package:movies_app/features/search/presentation/components/search_textfield.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: SearchTextField(
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchMultiEvent(query: query));
            },
            suffixIconOnTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const FiltersBottomSheet();
                },
              );
            },
            hintText: "Movies, series, persons",
            prefixIcon: Icons.search,
            suffixIcon: Icons.tune,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 75);
  }
}
