// word_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meaning_mate/models/word_model.dart';

class WordRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWord(String userEmail, Word word) async {
    try {
      await firestore
          .collection('users')
          .doc(userEmail)
          .collection('words')
          .doc(word.word)
          .set(word.toMap());
    } catch (e) {
      throw Exception('Error adding word: $e');
    }
  }
}
