

bool sameTypes<S, V>() {
  void func<X extends S>() {}
  return func is void Function<X extends V>();
}


String concatImageUrl({required String path, int? imageSize = 500}) {
  String url = "https://image.tmdb.org/t/p/w$imageSize$path";
  return url;
}
