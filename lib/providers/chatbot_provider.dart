import 'package:flutter/material.dart';
import 'package:meaning_mate/repositories/chatbot_repository.dart';

class ChatbotProvider with ChangeNotifier {
  final ChatbotRepository _repository;
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  ChatbotProvider({required String apiKey})
      : _repository = ChatbotRepository(apiKey: apiKey);

  List<Map<String, String>> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _messages.add({"role": "user", "content": userMessage});
    _isTyping = true;
    notifyListeners();

    try {
      final aiResponse = await _repository.generateResponse(userMessage);
      _messages.add({"role": "ai", "content": aiResponse});
    } catch (e) {
      _messages.add({
        "role": "ai",
        "content": "Error: Unable to generate a response. Please try again."
      });
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }
}
