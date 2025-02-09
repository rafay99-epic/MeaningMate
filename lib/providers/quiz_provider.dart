// APi Version
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/chatbot_repository.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_meaning.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_synonym.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_tense.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_antonym.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';

class QuizProvider extends ChangeNotifier {
  int _selectedTagIndex = 0;
  Word? _currentWord;
  String? _selectedAnswer;
  bool? _isCorrect;
  List<String> _answerOptions = [];
  String _correctAnswer = "";
  final ChatbotRepository _chatbotRepository;

  QuizProvider({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository;

  final List<String> quizTags = ['Meaning', 'Synonym', 'Tense', 'Antonym'];

  final List<Widget> _quizzes = [
    const QuizMeaning(),
    const QuizSynonym(),
    const QuizTense(),
    const QuizAntonym(),
  ];

  int get selectedTagIndex => _selectedTagIndex;
  Word? get currentWord => _currentWord;
  bool? get isCorrect => _isCorrect;
  String? get selectedAnswer => _selectedAnswer;
  List<String> get answerOptions => _answerOptions;
  Widget get currentQuiz => _quizzes[_selectedTagIndex];

  void updateQuiz(int index, BuildContext context) {
    _selectedTagIndex = index;
    _generateNewQuiz(context);
    notifyListeners();
  }

  void _generateNewQuiz(BuildContext context) async {
    final words =
        Provider.of<SearchProvider>(context, listen: false).filteredWords;
    if (words.isNotEmpty) {
      _currentWord = words[Random().nextInt(words.length)];
      await _generateAnswerOptions();
    } else {
      _currentWord = null;
      _answerOptions = [];
    }
    _isCorrect = null;
    _selectedAnswer = null;
    notifyListeners();
  }

  Future<void> _generateAnswerOptions() async {
    _answerOptions = [];
    if (_currentWord == null) return;

    // Determine correct answer
    switch (_selectedTagIndex) {
      case 0: // Meaning Quiz
        _correctAnswer = _cleanAnswer(_currentWord!.meaning.toString());
        break;
      case 1: // Synonym Quiz
        _correctAnswer = _cleanAnswer(_currentWord!.synonyms.isNotEmpty
            ? _currentWord!.synonyms.first
            : "");
        break;
      case 2: // Tense Quiz
        _correctAnswer = _cleanAnswer(
            _currentWord!.tenses.isNotEmpty ? _currentWord!.tenses.first : "");
        break;
      case 3: // Antonym Quiz
        _correctAnswer = _cleanAnswer(_currentWord!.antonyms.isNotEmpty
            ? _currentWord!.antonyms.first
            : "");
        break;
      default:
        _correctAnswer = "";
    }

    if (_correctAnswer.isEmpty) return;
    _answerOptions.add(_correctAnswer);

    // Generate incorrect options dynamically
    final prompt = _getPromptForWrongAnswers();
    final fakeResponses = await _chatbotRepository.generateResponse(prompt);

    // Process API response into a list of unique incorrect options
    final fakeOptions = fakeResponses
        .split('\n')
        .map((s) => _cleanAnswer(s.trim())) // Clean responses
        .where(
            (s) => s.isNotEmpty && _normalize(s) != _normalize(_correctAnswer))
        .toSet()
        .toList();

    // Ensure we have 3 incorrect options
    while (fakeOptions.length < 3) {
      fakeOptions.add("Random${fakeOptions.length + 1}");
    }

    // Add wrong answers & shuffle
    _answerOptions.addAll(fakeOptions.take(3));
    _answerOptions.shuffle();
    notifyListeners();
  }

  /// Returns an AI prompt to generate wrong answers based on the quiz type
  /// Returns an AI prompt to generate wrong answers based on the quiz type.
  /// Ensures the response matches the format of the correct answer (word vs. sentence).
  String _getPromptForWrongAnswers() {
    final word = _currentWord!.word;
    final isSentence =
        _correctAnswer.trim().contains(' '); // Check if it's a sentence

    switch (_selectedTagIndex) {
      case 0: // Meaning Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence definitions for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation"
            : "Generate three incorrect but plausible word meanings for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation";

      case 1: // Synonym Quiz
        return isSentence
            ? "Generate three incorrect but plausible phrases as synonyms for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation"
            : "Generate three incorrect but plausible single-word synonyms for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation";

      case 2: // Tense Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence-based tense variations for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation"
            : "Generate three incorrect but plausible word-based tense variations for '$word'. and don't explain anytjust simple give me sentence no heading, no punctuation, no explanation";

      case 3: // Antonym Quiz
        return isSentence
            ? "Generate three incorrect but plausible sentence-based antonyms for '$word'. and don't explain anytjust simple give me"
            : "Generate three incorrect but plausible single-word antonyms for '$word'. and don't explain anytjust simple give me";

      default:
        return "";
    }
  }

  void checkAnswer(String answer) {
    _isCorrect = _normalize(answer) == _normalize(_correctAnswer);
    _selectedAnswer = answer;
    notifyListeners();
  }

  /// Normalize text to improve comparison (ignores case & trims spaces)
  String _normalize(String text) {
    return text.trim().toLowerCase();
  }

  String _cleanAnswer(String answer) {
    final keywordPattern = RegExp(r'^\*\*(\w+)\s*:\*\*', caseSensitive: false);
    return answer
        .replaceAll(keywordPattern, '') // Remove "**Keyword:**"
        .trim(); // Remove leading and trailing spaces
  }
}
