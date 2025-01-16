class Word {
  String word;
  String meaning;
  List<String> sentences;
  List<String> synonyms;
  List<String> antonyms;

  Word({
    required this.word,
    required this.meaning,
    required this.sentences,
    required this.synonyms,
    required this.antonyms,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'sentences': sentences,
      'synonyms': synonyms,
      'antonyms': antonyms,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      meaning: map['meaning'] ?? '',
      sentences: List<String>.from(map['sentences'] ?? []),
      synonyms: List<String>.from(map['synonyms'] ?? []),
      antonyms: List<String>.from(map['antonyms'] ?? []),
    );
  }
}
