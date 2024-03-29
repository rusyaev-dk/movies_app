import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/features/watch_list/presentation/components/watch_list_additional.dart';
import 'package:movies_app/features/watch_list/presentation/watch_list_bloc/watch_list_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

class WatchListBody extends StatelessWidget {
  const WatchListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListBloc, WatchListState>(
      builder: (context, state) {
        if (state is WatchListFailureState) {
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
                onPressed: () => context
                    .read<WatchListBloc>()
                    .add(WatchListLoadWatchListEvent()),
              );
            default:
              return FailureWidget(
                failure: state.failure,
                onPressed: () => context
                    .read<WatchListBloc>()
                    .add(WatchListLoadWatchListEvent()),
              );
          }
        }

        if (state is WatchListLoadingState) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: WatchListContent.shimmerLoading(context),
          );
        }

        if (state is WatchListLoadedState) {
          if (state.moviesWatchList.isEmpty &&
              state.tvSeriesWatchList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: NoAddedWatchListMedia(),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: WatchListContent(
              moviesWatchList: state.moviesWatchList,
              tvSeriesWatchList: state.tvSeriesWatchList,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: WatchListContent.shimmerLoading(context),
        );
      },
    );
  }
}

class WatchListContent extends StatelessWidget {
  const WatchListContent({
    super.key,
    required this.moviesWatchList,
    required this.tvSeriesWatchList,
  });

  final List<MovieModel> moviesWatchList;
  final List<TVSeriesModel> tvSeriesWatchList;

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: Column(
        children: [
          MediaHorizontalListView.shimmerLoading(
            context,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView.shimmerLoading(context,
              cardHeight: 210, cardWidth: 140),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    return SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () => context.read<WatchListBloc>().add(
          WatchListRefreshWatchListEvent(refreshController: refreshController)),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          MediaHorizontalListView(
            models: moviesWatchList,
            withAllButton: moviesWatchList.length > 10,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 10),
          MediaHorizontalListView(
            models: tvSeriesWatchList,
            withAllButton: moviesWatchList.length > 10,
            cardHeight: 210,
            cardWidth: 140,
          ),
        ],
      ),
    );
  }
}
