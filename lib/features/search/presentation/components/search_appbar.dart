import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/search/presentation/components/search_textfield.dart';
import 'package:movies_app/features/search/presentation/search_bloc/search_bloc.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SearchTextField(
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchMultiEvent(query));
          },
          suffixIconOnTap: () {
            context.read<SearchBloc>().add(SearchOpenFiltersEvent());
          },
          hintText: "Movies, series, persons",
          prefixIcon: Icons.search,
          suffixIcon: Icons.tune,
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 75);
  }
}
