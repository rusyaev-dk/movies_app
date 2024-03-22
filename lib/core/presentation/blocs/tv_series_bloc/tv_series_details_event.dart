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
