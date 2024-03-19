part of 'media_details_bloc.dart';

class MediaDetailsEvent {}

class MediaDetailsLoadDetailsEvent extends MediaDetailsEvent {
  final String locale;
  final TMDBMediaType mediaType;
  final int mediaId;

  MediaDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.mediaType,
    required this.mediaId,
  });
}

class MediaDetailsNetworkErrorEvent extends MediaDetailsEvent {}