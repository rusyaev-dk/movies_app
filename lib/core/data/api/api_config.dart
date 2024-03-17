
abstract class ApiConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageUrl = 'https://image.tmdb.org/t/p';

  static const String newTokenPath = "/authentication/token/new";
  static const String validateWithLoginPath =
      "/authentication/token/validate_with_login";
  static const String newSessionPath = "/authentication/session/new";

  static const String accountPath = "/account";

  static const String popularMoviesPath = "/movie/popular";
  static const String trendingMoviesPath = "/trending/movie/day";
  static const String popularTVSeriesPath = "/tv/popular";
  static const String trendingTVSeriesPath = "/trending/tv/day";
  static const String searchMultiMediaPath = "/search/multi";
}
