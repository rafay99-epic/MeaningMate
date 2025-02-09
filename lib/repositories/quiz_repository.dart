import 'package:meaning_mate/models/word_model.dart';

class QuizRepo {
  static bool checkAnswer(int quizIndex, Word? word, String answer) {
    if (word == null) return false;
    switch (quizIndex) {
      case 0: // Meaning Quiz
        return word.meaning.contains(answer);
      case 1: // Synonym Quiz
        return word.synonyms.contains(answer);
      case 2: // Tense Quiz
        return word.tenses.contains(answer);
      case 3: // Antonym Quiz
        return word.antonyms.contains(answer);
      default:
        return false;
    }
  }
}
