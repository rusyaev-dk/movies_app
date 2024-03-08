part of 'tmdb_media_bloc.dart';

class TMDBMediaEvent {}

class TMDBMediaAllMediaEvent extends TMDBMediaEvent {
  final String locale;
  final int page;

  TMDBMediaAllMediaEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class TMDBMediaPopularMoviesEvent extends TMDBMediaEvent {
  final String locale;
  final int page;

  TMDBMediaPopularMoviesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class TMDBMediaTrendingMoviesEvent extends TMDBMediaEvent {
  final String locale;
  final int page;

  TMDBMediaTrendingMoviesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}
