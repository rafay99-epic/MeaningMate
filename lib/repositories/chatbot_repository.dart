import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotRepository {
  final GenerativeModel _model;

  ChatbotRepository({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
        );

  /// Validates and sanitizes the input prompt
  String _sanitizePrompt(String prompt) {
    final sanitized = prompt.trim();
    if (sanitized.isEmpty) {
      throw ArgumentError('Prompt cannot be empty');
    }
    return sanitized;
  }

  /// Generates a response for the given prompt
  Future<String> generateResponse(String prompt) async {
    try {
      final sanitizedPrompt = _sanitizePrompt(prompt);
      final content = [Content.text(sanitizedPrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "I couldn't generate a response.";
    } catch (e) {
      if (e is ArgumentError) {
        return "Invalid input: ${e.message}";
      }
      return "An error occurred while processing your request.";
    }
  }
}
