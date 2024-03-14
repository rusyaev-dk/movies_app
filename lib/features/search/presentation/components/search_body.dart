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
            if (state is SearchFailureState) {
              switch (state.exception!.type) {
                case ApiClientExceptionType.network:
                  return ExceptionWidget(
                    exception: state.exception!,
                    buttonText: "Update",
                    icon: Icons.wifi_off,
              
                  );
                case ApiClientExceptionType.sessionExpired:
                  return ExceptionWidget(
                    exception: state.exception!,
                    buttonText: "Login",
                    icon: Icons.login,
                    onPressed: () => context.go(AppRoutes.auth),
                  );
                default:
                  return ExceptionWidget(
                    exception: state.exception!,
                    buttonText: "Update",
                    icon: Icons.error_outline_outlined,
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
              child: Text(
                "Let's find something!",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            );
          },
        ),
      ),
    );
  }
}
