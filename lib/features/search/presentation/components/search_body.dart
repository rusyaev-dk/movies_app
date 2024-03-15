import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/presentation/blocs/auth_bloc/auth_bloc.dart';
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
            if (state is SearchFailureState) {
              switch (state.exception!.type) {
                case (ApiClientExceptionType.sessionExpired):
                  return ExceptionWidget(
                      exception: state.exception!,
                      buttonText: "Login",
                      icon: Icons.exit_to_app_outlined,
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                        context.go(AppRoutes.screenLoader);
                      });
                case (ApiClientExceptionType.network):
                  return ExceptionWidget(
                    exception: state.exception!,
                    buttonText: "Update",
                    icon: Icons.wifi_off,
                    onPressed: state.query != null
                        ? () => context
                            .read<SearchBloc>()
                            .add(SearchMultiEvent(query: state.query!))
                        : null,
                  );
                default:
                  return ExceptionWidget(
                    exception: state.exception!,
                  );
              }
            }

            if (state is SearchLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SearchLoadedState) {
              return SearchList(models: state.searchModels);
            }

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.movie_creation_outlined,
                    size: 160,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Let's find something!",
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .headingTextStyle
                        .copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
