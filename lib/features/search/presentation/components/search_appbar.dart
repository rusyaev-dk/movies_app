import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/components/filters_bottom_sheet/filters_bottom_sheet.dart';
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
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: SearchTextField(
                  onChanged: (query) {
                    context
                        .read<SearchBloc>()
                        .add(SearchMultiEvent(query: query));
                  },
                  hintText: "Movies, series, persons",
                  prefixIcon: Icons.search,
                  suffixIcon: Icons.tune,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                flex: 1,
                child: FiltersButton(),
              )
            ],
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

class FiltersButton extends StatelessWidget {
  const FiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const FiltersBottomSheet();
          },
        );
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Icon(
          Icons.tune,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
