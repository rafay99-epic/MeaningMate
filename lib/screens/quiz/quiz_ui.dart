import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Quizui extends StatelessWidget {
  final String question;
  final List<String> options;
  final void Function(String) onOptionSelected;

  const Quizui({
    super.key,
    required this.question,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            children: options
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () => onOptionSelected(option),
                        child: MarkdownBody(
                          data: option,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
