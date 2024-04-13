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
import 'package:movies_app/features/watchlist/presentation/components/watchlist_additional.dart';
import 'package:movies_app/features/watchlist/presentation/watchlist_bloc/watchlist_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

class WatchlistBody extends StatelessWidget {
  const WatchlistBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistFailureState) {
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
                    .read<WatchlistBloc>()
                    .add(WatchlistloadWatchlistEvent()),
              );
            default:
              return FailureWidget(
                failure: state.failure,
                onPressed: () => context
                    .read<WatchlistBloc>()
                    .add(WatchlistloadWatchlistEvent()),
              );
          }
        } else if (state is WatchlistLoadedState) {
          if (state.moviesWatchlist.isEmpty &&
              state.tvSeriesWatchlist.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: NoAddedWatchlistMedia(),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: WatchlistContent(
              moviesWatchlist: state.moviesWatchlist,
              tvSeriesWatchlist: state.tvSeriesWatchlist,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: WatchlistContent.shimmerLoading(context),
          );
        }
      },
    );
  }
}

class WatchlistContent extends StatefulWidget {
  const WatchlistContent({
    super.key,
    required this.moviesWatchlist,
    required this.tvSeriesWatchlist,
  });

  final List<MovieModel> moviesWatchlist;
  final List<TVSeriesModel> tvSeriesWatchlist;

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
  State<WatchlistContent> createState() => _WatchlistContentState();
}

class _WatchlistContentState extends State<WatchlistContent> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: () => context.read<WatchlistBloc>().add(
          WatchlistRefreshWatchlistEvent(
              refreshController: _refreshController)),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          MediaHorizontalListView(
            title: "Your movies",
            models: widget.moviesWatchlist,
            withAllButton: widget.moviesWatchlist.length > 10,
            cardHeight: 210,
            cardWidth: 140,
          ),
          const SizedBox(height: 20),
          MediaHorizontalListView(
            title: "Your TV series",
            models: widget.tvSeriesWatchlist,
            withAllButton: widget.moviesWatchlist.length > 10,
            cardHeight: 210,
            cardWidth: 140,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
