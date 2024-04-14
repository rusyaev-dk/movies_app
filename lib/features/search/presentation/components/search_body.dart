import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/search/presentation/components/search_additional.dart';
import 'package:movies_app/features/search/presentation/components/search_list.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchFailureState) {
          switch (state.failure.type) {
            case (ApiClientExceptionType.sessionExpired):
              return FailureWidget(
                  failure: state.failure,
                  buttonText: "Login",
                  icon: Icons.exit_to_app_outlined,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                    context.go(AppRoutes.screenLoader);
                  });
            case (ApiClientExceptionType.network):
              return FailureWidget(
                failure: state.failure,
                buttonText: "Update",
                icon: Icons.wifi_off,
                onPressed: state.query != null
                    ? () => context
                        .read<SearchBloc>()
                        .add(SearchMediaEvent(query: state.query!))
                    : null,
              );
            default:
              return FailureWidget(
                failure: state.failure,
              );
          }
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
