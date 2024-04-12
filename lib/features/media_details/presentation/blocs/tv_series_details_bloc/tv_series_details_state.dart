part of 'tv_series_details_bloc.dart';

class TVSeriesDetailsState {
  final TVSeriesModel? tvSeriesModel;
  final bool? isFavourite;
  final bool? isInWatchlist;
  final List<MediaImageModel>? tvSeriesImages;
  final List<PersonModel>? tvSeriesCredits;
  final List<TVSeriesModel>? similarTVSeries;
  final ApiRepositoryFailure? failure;
  final int? tvSeriesId;
  final bool isLoading;

  TVSeriesDetailsState({
    this.tvSeriesModel,
    this.isFavourite,
    this.isInWatchlist,
    this.tvSeriesImages,
    this.tvSeriesCredits,
    this.similarTVSeries,
    this.failure,
    this.tvSeriesId,
    this.isLoading = false,
  });

  TVSeriesDetailsState copyWith({
    TVSeriesModel? tvSeriesModel,
    bool? isFavourite,
    bool? isInWatchlist,
    List<MediaImageModel>? tvSeriesImages,
    List<PersonModel>? tvSeriesCredits,
    List<TVSeriesModel>? similarTVSeries,
    ApiRepositoryFailure? failure,
    int? tvSeriesId,
    bool? isLoading = false,
  }) {
    return TVSeriesDetailsState(
      tvSeriesModel: tvSeriesModel ?? this.tvSeriesModel,
      isFavourite: isFavourite ?? this.isFavourite,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      tvSeriesImages: tvSeriesImages ?? this.tvSeriesImages,
      tvSeriesCredits: tvSeriesCredits ?? this.tvSeriesCredits,
      similarTVSeries: similarTVSeries ?? this.similarTVSeries,
      failure: failure ?? this.failure,
      tvSeriesId: tvSeriesId ?? this.tvSeriesId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


