part of 'tv_series_details_bloc.dart';

sealed class TvSeriesDetailsEvent extends Equatable {}

final class TVSeriesDetailsLoadDetailsEvent extends TvSeriesDetailsEvent {
  final String locale;
  final int tvSeriesId;

  TVSeriesDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.tvSeriesId,
  });

  @override
  List<Object?> get props => [
        locale,
        tvSeriesId,
      ];
}

final class TVSeriesDetailsAddToFavouriteEvent extends TvSeriesDetailsEvent {
  final int tvSeriesId;
  final bool isFavorite;

  TVSeriesDetailsAddToFavouriteEvent({
    required this.tvSeriesId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
        tvSeriesId,
        isFavorite,
      ];
}

final class TVSeriesDetailsAddToWatchlistEvent extends TvSeriesDetailsEvent {
  final int tvSeriesId;
  final bool isInWatchlist;

  TVSeriesDetailsAddToWatchlistEvent({
    required this.tvSeriesId,
    required this.isInWatchlist,
  });

  @override
  List<Object?> get props => [
        tvSeriesId,
        isInWatchlist,
      ];
}
