import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/presentation/components/exception_widget.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
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
            if (state.exception != null) {
              if (state.exception!.type ==
                  ApiClientExceptionType.sessionExpired) {
                context.go(AppRoutes.auth);
              }

              return ExceptionWidget(
                exception: state.exception!,
                buttonText: "Update",
                icon: Icons.wifi_off,
                onPressed: () {
                  context
                      .read<SearchBloc>()
                      .add(SearchMultiEvent(query: state.query!));
                },
              );
            }

            if (state.searchModels.isEmpty) {
              return Center(
                  child: Text(
                "Let's find something!",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ));
            }

            return SearchList(models: state.searchModels);
          },
        ),
      ),
    );
  }
}
