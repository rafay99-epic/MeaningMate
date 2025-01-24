import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotRepository {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  ChatbotRepository({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
        ),
        _firestore = FirebaseFirestore.instance;

  /// Limit Constants
  static const int dailyLimit = 50; // Requests Per Day
  static const int rpmLimit = 2; // Requests Per Minute
  static const int tokenLimitPerMinute = 32000; // Tokens Per Minute

  /// Checks and updates the user's usage limit in Firestore
  Future<bool> _checkAndUpdateUsage(String userEmail, int tokenCount) async {
    final currentDate = DateTime.now().toIso8601String().split('T').first;
    final currentMinute =
        DateTime.now().toIso8601String().split(':').sublist(0, 2).join(':');
    final userDoc = _firestore.collection('user_usage_api').doc(userEmail);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'usageCount': 1,
        'lastUpdated': currentDate,
        'minuteUsage': {currentMinute: 1},
        'tokenCount': tokenCount,
      });
      return true;
    }

    final data = docSnapshot.data()!;
    final lastUpdated = data['lastUpdated'] as String? ?? '';
    final usageCount = data['usageCount'] as int? ?? 0;
    final minuteUsage = Map<String, int>.from(data['minuteUsage'] ?? {});
    final currentTokenCount = data['tokenCount'] as int? ?? 0;

    // Check Daily Limit
    if (lastUpdated == currentDate) {
      if (usageCount >= dailyLimit) {
        return false;
      }
    } else {
      await userDoc.set({
        'usageCount': 0,
        'lastUpdated': currentDate,
        'minuteUsage': {},
        'tokenCount': 0,
      });
    }

    final currentMinuteUsage = minuteUsage[currentMinute] ?? 0;
    if (currentMinuteUsage >= rpmLimit) {
      return false;
    }

    if (currentTokenCount + tokenCount > tokenLimitPerMinute) {
      return false;
    }

    // Update usage
    await userDoc.update({
      'usageCount': FieldValue.increment(1),
      'minuteUsage.$currentMinute': FieldValue.increment(1),
      'tokenCount': FieldValue.increment(tokenCount),
    });

    return true;
  }

  Future<String> generateResponse(String prompt) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return "Unable to determine the current user. Please log in.";
    }

    final userEmail = user.email!;

    final int promptTokenCount = (prompt.length / 4).ceil();

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    final responseText = response.text ?? "I couldn't generate a response.";
    final int responseTokenCount = (responseText.length / 4).ceil();

    final int totalTokenCount = promptTokenCount + responseTokenCount;

    final withinLimit = await _checkAndUpdateUsage(userEmail, totalTokenCount);

    if (!withinLimit) {
      throw LimitExceededException(
          "You have exceeded your request limits. Please try again later or upgrade to a premium plan.");
    }

    return responseText;
  }
}

class LimitExceededException implements Exception {
  final String message;

  LimitExceededException(this.message);

  @override
  String toString() => message;
}
