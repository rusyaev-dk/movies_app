
bool sameTypes<S, V>() {
  void func<X extends S>() {}
  return func is void Function<X extends V>();
}

int countSentences(String text) {
  if (text.isEmpty) {
    return 0;
  }

  final RegExp sentenceEndPattern = RegExp(r'[.!?]');

  final List<String> sentences = text.split(sentenceEndPattern);
  
  sentences.removeWhere((sentence) => sentence.trim().isEmpty);

  return sentences.length;
}
