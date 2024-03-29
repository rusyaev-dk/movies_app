part of 'tv_series_details_bloc.dart';

class TVSeriesDetailsState {}

class TVSeriesDetailsLoadingState extends TVSeriesDetailsState {}

class TVSeriesDetailsLoadedState extends TVSeriesDetailsState {
  final TVSeriesModel tvSeriesModel;
  final List<MediaImageModel>? tvSeriesImages;
  final List<PersonModel>? tvSeriesCredits;

  TVSeriesDetailsLoadedState({
    required this.tvSeriesModel,
    this.tvSeriesImages,
    this.tvSeriesCredits,
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
