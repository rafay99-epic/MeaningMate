import 'package:meaning_mate/repositories/chatbot_repository.dart';

class QuizRepository {
  final ChatbotRepository _chatbotRepository;

  QuizRepository({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository;

  Future<List<String>> generateFakeOptions(
      String correctAnswer, String word, int quizType) async {
    final prompt = _getPromptForWrongAnswers(correctAnswer, word, quizType);
    final fakeResponses = await _chatbotRepository.generateResponse(prompt);

    final fakeOptions = fakeResponses
        .split('\n')
        .map((s) => s.trim())
        .where(
            (s) => s.isNotEmpty && _normalize(s) != _normalize(correctAnswer))
        .toSet()
        .toList();

    while (fakeOptions.length < 3) {
      fakeOptions.add("Random${fakeOptions.length + 1}");
    }

    fakeOptions.shuffle();
    return fakeOptions.take(3).toList();
  }

  String _getPromptForWrongAnswers(
      String correctAnswer, String word, int quizType) {
    final isSentence = correctAnswer.trim().contains(' ');

    switch (quizType) {
      case 0: // Meaning Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence definitions for '$word'."
            : "Generate three incorrect but plausible word meanings for '$word'.";
      case 1: // Synonym Quiz
        return isSentence
            ? "Generate three incorrect but plausible phrases as synonyms for '$word'."
            : "Generate three incorrect but plausible single-word synonyms for '$word'.";
      case 2: // Tense Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence-based tense variations for '$word'."
            : "Generate three incorrect but plausible word-based tense variations for '$word'.";
      case 3: // Antonym Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence-based antonyms for '$word'."
            : "Generate three incorrect but plausible single-word antonyms for '$word'.";
      default:
        return "";
    }
  }

  String _normalize(String text) {
    return text.trim().toLowerCase();
  }
}
