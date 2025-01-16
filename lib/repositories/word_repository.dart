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

  Future<void> deleteWord(String word) async {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      await firestore
          .collection('users')
          .doc(userEmail)
          .collection('words')
          .doc(word)
          .delete();
    } catch (e) {
      throw Exception('Error deleting word: $e');
    }
  }

  Stream<List<Word>> searchWords(String query) {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      final stream = firestore
          .collection('users')
          .doc(userEmail)
          .collection('words')
          .where('word', isGreaterThanOrEqualTo: query)
          .where('word', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots();

      return stream.map((snapshot) =>
          snapshot.docs.map((doc) => Word.fromMap(doc.data())).toList());
    } catch (e) {
      throw Exception('Error searching words: $e');
    }
  }

  Stream<List<Word>> getAllWordsStream() {
    final userEmail = _getCurrentUserEmail();
    if (userEmail == null) {
      throw Exception('No user is currently logged in.');
    }

    return firestore
        .collection('users')
        .doc(userEmail)
        .collection('words')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Word.fromMap(doc.data())).toList());
  }
}
