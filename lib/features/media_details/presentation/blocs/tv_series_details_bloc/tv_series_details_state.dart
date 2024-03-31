part of 'tv_series_details_bloc.dart';

class TVSeriesDetailsState {}

class TVSeriesDetailsLoadingState extends TVSeriesDetailsState {}

class TVSeriesDetailsLoadedState extends TVSeriesDetailsState {
  final TVSeriesModel tvSeriesModel;
  final List<MediaImageModel>? tvSeriesImages;
  final List<PersonModel>? tvSeriesCredits;
  final List<TVSeriesModel>? similarTVSeries;

  TVSeriesDetailsLoadedState({
    required this.tvSeriesModel,
    this.tvSeriesImages,
    this.tvSeriesCredits,
    this.similarTVSeries,
  });
}

class TVSeriesDetailsFailureState extends TVSeriesDetailsState {
  final RepositoryFailure failure;
  final int? tvSeriesId;

  TVSeriesDetailsFailureState({
    required this.failure,
    this.tvSeriesId,
  });
}
