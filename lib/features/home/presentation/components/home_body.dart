import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeFailureState) {
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
                onPressed: () =>
                    context.read<HomeBloc>().add(HomeLoadMediaEvent()),
              );
            default:
              return FailureWidget(
                failure: state.failure,
                onPressed: () =>
                    context.read<HomeBloc>().add(HomeLoadMediaEvent()),
              );
          }
        }

        if (state is HomeLoadingState) {
          return const Padding(
            padding: EdgeInsets.only(left: 10),
            child: HomeLoadingBody(),
          );
        }

        if (state is HomeLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView(
              children: [
                MediaHorizontalListView(
                  title: "Popular movies for you",
                  models: state.popularMovies,
                  cardHeight: 270,
                  cardWidth: 180,
                ),
                const SizedBox(height: 20),
                MediaHorizontalListView(
                  title: "Trending movies",
                  models: state.trendingMovies,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                MediaHorizontalListView(
                  title: "Popular TV series",
                  models: state.popularTVSeries,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
                const SizedBox(height: 20),
                MediaHorizontalListView(
                  title: "Trending TV series",
                  models: state.trendingTVSeries,
                  cardHeight: 210,
                  cardWidth: 140,
                ),
              ],
            ),
          );
        }

        return const HomeLoadingBody();
      },
    );
  }
}

class HomeLoadingBody extends StatelessWidget {
  const HomeLoadingBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 270, cardWidth: 180),
        const SizedBox(height: 20),
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 210, cardWidth: 140),
        const SizedBox(height: 20),
        MediaHorizontalListView.shimmerLoading(context,
            cardHeight: 210, cardWidth: 140),
      ],
    );
  }
}
