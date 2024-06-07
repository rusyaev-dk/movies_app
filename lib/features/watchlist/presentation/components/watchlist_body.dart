import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/watchlist/presentation/components/watchlist_additional.dart';
import 'package:movies_app/features/watchlist/presentation/components/watchlist_failure_widget.dart';
import 'package:movies_app/features/watchlist/presentation/watchlist_bloc/watchlist_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WatchlistBody extends StatelessWidget {
  const WatchlistBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final completer = Completer();
        BlocProvider.of<WatchlistBloc>(context)
            .add(WatchlistloadWatchlistEvent(completer: completer));
        return completer.future;
      },
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistFailureState) {
            return WatchlistFailureWidget(failure: state.failure);
          } else if (state is WatchlistLoadedState) {
            if (state.moviesWatchlist.isEmpty &&
                state.tvSeriesWatchlist.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: NoAddedWatchlistMedia(),
              );
            }
            return WatchlistContent(
              moviesWatchlist: state.moviesWatchlist,
              tvSeriesWatchlist: state.tvSeriesWatchlist,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: WatchlistContent.shimmerLoading(context),
            );
          }
        },
      ),
    );
  }
}

class WatchlistContent extends StatelessWidget {
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
          const SizedBox(height: 30),
          MediaHorizontalListView.shimmerLoading(
            context,
            cardHeight: 210,
            cardWidth: 140,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 1,
      itemBuilder: (context, _) {
        return Animate(
          effects: const [FadeEffect()],
          child: Column(
            children: [
              MediaHorizontalListView(
                title: "Your movies",
                models: moviesWatchlist,
                withAllButton: false,
                cardHeight: 210,
                cardWidth: 140,
              ),
              const SizedBox(height: 20),
              MediaHorizontalListView(
                title: "Your TV series",
                models: tvSeriesWatchlist,
                withAllButton: false,
                cardHeight: 210,
                cardWidth: 140,
              ),
            ],
          ),
        );
      },
    );
  }
}
