class ApiMediaGenresFormatter {
  static List<String> genreIdsToList({required List<dynamic> genreIds}) {
    List<String> resultList = [];
    for (int genreId in genreIds) {
      resultList.add(_genresMap[genreId] ?? "");
    }
    return resultList;
  }

  static String genreIdsToString({required List<dynamic>? genreIds}) {
    if (genreIds == null) return "";

    String resultString = "";
    int length = genreIds.length;
    for (int i = 0; i < length; i++) {
      String? genreName = _genresMap[genreIds[i]];
      if (genreName != null) {
        resultString += genreName;
        if (i < length - 1 && length > 1) {
          resultString += ', ';
        }
      }
    }
    return resultString;
  }

  static const Map<int, String> _genresMap = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
    10759: "Action & Adventure",
    10762: "Kids",
    10763: "News",
    10764: "Reality",
    10765: "Sci-Fi & Fantasy",
    10766: "Soap",
    10767: "Talk",
    10768: "War & Politics",
  };
}
