part of 'media_details_bloc.dart';

class MediaDetailsState {}

class MediaDetailsLoadingState extends MediaDetailsState {}

class MediaDetailsLoadedState extends MediaDetailsState {
  final TMDBModel mediaModel;

  MediaDetailsLoadedState({required this.mediaModel});
}

class MediaDetailsFailureState extends MediaDetailsState {
  final RepositoryFailure failure;
  final int? mediaId;

  MediaDetailsFailureState({
    required this.failure,
    this.mediaId,
  });
}