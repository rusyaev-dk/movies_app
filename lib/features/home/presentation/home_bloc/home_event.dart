part of 'home_bloc.dart';

class HomeEvent {}

class HomeLoadMediaEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadMediaEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeLoadPopularMoviesEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadPopularMoviesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeLoadTrendingMoviesEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadTrendingMoviesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeLoadPopularTVSeriesEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadPopularTVSeriesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeLoadTrendingTVSeriesEvent extends HomeEvent {
  final String locale;
  final int page;

  HomeLoadTrendingTVSeriesEvent({
    this.locale = "en-US",
    this.page = 1,
  });
}

class HomeNetworkErrorEvent extends HomeEvent {}

// class TMDBMediaMovieDetailsEvent extends TMDBMediaEvent {
//   final String locale;
//   final int movieId;

//   TMDBMediaMovieDetailsEvent({
//     this.locale = "en-US",
//     required this.movieId,
//   });
// }
