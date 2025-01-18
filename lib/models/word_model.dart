class Word {
  String word;
  List<String> meaning;
  List<String> sentences;
  List<String> synonyms;
  List<String> antonyms;
  List<String> tenses;

  Word({
    required this.word,
    required this.meaning,
    required this.sentences,
    required this.synonyms,
    required this.antonyms,
    required this.tenses,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meanings': meaning,
      'sentences': sentences,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'tenses': tenses,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      meaning: List<String>.from(map['meanings'] ?? []),
      sentences: List<String>.from(map['sentences'] ?? []),
      synonyms: List<String>.from(map['synonyms'] ?? []),
      antonyms: List<String>.from(map['antonyms'] ?? []),
      tenses: List<String>.from(map['tenses'] ?? []),
    );
  }
}
