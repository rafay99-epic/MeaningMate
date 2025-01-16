import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meaning_mate/models/word_model.dart';

class WordRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? _getCurrentUserEmail() {
    final user = auth.currentUser;
    return user?.email;
  }

  Future<void> addWord(Word word) async {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

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

  // 1. Search through words for the current user
  Future<List<Word>> searchWords(String query) async {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userEmail)
          .collection('words')
          .where('word', isGreaterThanOrEqualTo: query)
          .where('word', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs.map((doc) => Word.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Error searching words: $e');
    }
  }

  // 2. Display all words for the current user
  Future<List<Word>> getAllWords() async {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userEmail)
          .collection('words')
          .get();

      return snapshot.docs.map((doc) => Word.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching words: $e');
    }
  }
}
