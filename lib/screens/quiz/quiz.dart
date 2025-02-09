import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meaning_mate/providers/quiz_provider.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _quizStarted = false;

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuiz = quizProvider.currentQuiz;
    const logo = QuizScreenImage.logo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_quizStarted) ...[
              // Animated SVG Image
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 200,
                width: 200,
                child: SvgPicture.asset(
                  logo,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              // Decorative Text
              Text(
                'Test Your Knowledge',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Challenge yourself with our interactive quiz!',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _quizStarted = true;
                      quizProvider.updateQuiz(0, context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: const Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            if (_quizStarted) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: List.generate(
                    quizProvider.quizTags.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ChoiceChip(
                        label: Text(
                          quizProvider.quizTags[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: quizProvider.selectedTagIndex == index
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        selected: quizProvider.selectedTagIndex == index,
                        onSelected: (selected) {
                          quizProvider.updateQuiz(index, context);
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                    ),
                  ),
                ),
              ),
              // Quiz Content with Fade Animation
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: currentQuiz,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
