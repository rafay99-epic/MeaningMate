import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/word_repository.dart';

class SearchProvider extends ChangeNotifier {
  final WordRepository wordRepository;
  List<Word> _words = [];
  List<Word> get words => _words;

  List<Word> _filteredWords = [];
  List<Word> get filteredWords => _filteredWords;

  SearchProvider({required this.wordRepository});

  /// Fetch all words from the repository
  void fetchAllWords() {
    try {
      wordRepository.getAllWordsStream().listen(
        (wordList) {
          _words = wordList;
          _filteredWords = wordList;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Error fetching words stream: $error');
          _words = [];
          _filteredWords = [];
          notifyListeners();
        },
        cancelOnError: true,
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error fetching words: $e');
      debugPrintStack(stackTrace: stackTrace);
      _words = [];
      _filteredWords = [];
      notifyListeners();
    }
  }

  /// Search words based on the query
  void searchWords(String query) {
    try {
      if (_words.isEmpty) {
        debugPrint('Warning: Attempted to search in an empty word list.');
        _filteredWords = [];
        notifyListeners();
        return;
      }

      if (query.isEmpty) {
        _filteredWords = _words;
      } else {
        final lowerQuery = query.toLowerCase();

        _filteredWords = _words.where((word) {
          try {
            return word.word.toLowerCase().contains(lowerQuery) ||
                word.meaning.any(
                    (meaning) => meaning.toLowerCase().contains(lowerQuery)) ||
                word.sentences.any((sentence) =>
                    sentence.toLowerCase().contains(lowerQuery)) ||
                word.synonyms.any(
                    (synonym) => synonym.toLowerCase().contains(lowerQuery)) ||
                word.antonyms.any(
                    (antonym) => antonym.toLowerCase().contains(lowerQuery)) ||
                word.tenses
                    .any((tense) => tense.toLowerCase().contains(lowerQuery));
          } catch (e) {
            debugPrint('Error searching in word: $e');
            return false;
          }
        }).toList();
      }

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error during search: $e');
      debugPrintStack(stackTrace: stackTrace);
      _filteredWords = [];
      notifyListeners();
    }
  }
}
