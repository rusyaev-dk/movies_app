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
  static const String searchMoviesPath = "/search/movie";
  static const String searchTVSeriesPath = "/search/tv";
  static const String searchPersonsPath = "/search/person";
  
  static const String moviePath = "/movie";
  static const String tvSeriesPath = "/tv";
  static const String personPath = "/person";
  static const String imagesPath = "images";
  static const String creditsPath = "credits";
  static const String similarPath = "similar";

}
