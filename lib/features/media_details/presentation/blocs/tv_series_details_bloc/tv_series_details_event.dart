part of 'tv_series_details_bloc.dart';

class TvSeriesDetailsEvent {}

class TVSeriesDetailsLoadDetailsEvent extends TvSeriesDetailsEvent {
  final String locale;
  final int tvSeriesId;

  TVSeriesDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.tvSeriesId,
  });
}

class TVSeriesDetailsAddToFavouriteEvent extends TvSeriesDetailsEvent {
  final int tvSeriesId;
  final bool isFavorite;

  TVSeriesDetailsAddToFavouriteEvent({
    required this.tvSeriesId,
    required this.isFavorite,
  });
}

class TVSeriesDetailsAddToWatchlistEvent extends TvSeriesDetailsEvent {
  final int tvSeriesId;
  final bool isInWatchlist;

  TVSeriesDetailsAddToWatchlistEvent({
    required this.tvSeriesId,
    required this.isInWatchlist,
  });
}
