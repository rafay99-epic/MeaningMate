import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meaning_mate/firebase_options.dart';
import 'package:meaning_mate/providers/chatbot_provider.dart';
import 'package:meaning_mate/repositories/chatbot_repository.dart';
import 'package:meaning_mate/providers/layout_provider.dart';
import 'package:meaning_mate/providers/quiz_provider.dart';
import 'package:meaning_mate/providers/search_provider.dart';
import 'package:meaning_mate/repositories/auth_repository.dart';
import 'package:meaning_mate/repositories/quiz_repository.dart';
import 'package:meaning_mate/repositories/word_repository.dart';
import 'package:meaning_mate/screens/errorhandelling/error_handelling.dart';
import 'package:meaning_mate/screens/home/home_screen.dart';
import 'package:meaning_mate/screens/splash/splash_screen.dart';
import 'package:meaning_mate/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class MyApp extends StatelessWidget {
  final bool isFirebaseInitialized;
  final bool isLoggedIn;
  final String? errorMessage;

  const MyApp({
    super.key,
    required this.isFirebaseInitialized,
    required this.isLoggedIn,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseInitialized) {
      return MaterialApp(
        theme: basecolors,
        home: ErrorScreen(errorMessage: errorMessage ?? 'Unknown error'),
        debugShowCheckedModeBanner: false,
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(wordRepository: WordRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => LayoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatbotProvider(apiKey: ''),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(
            quizRepository: QuizRepository(
              chatbotRepository: ChatbotRepository(apiKey: ""),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: basecolors,
        home: isLoggedIn ? const Home() : const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseInitialized = false;
  bool isLoggedIn = false;
  String? errorMessage;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;

    final ShorebirdUpdater updater = ShorebirdUpdater();

    final updateStatus = await updater.checkForUpdate();
    if (updateStatus == UpdateStatus.outdated) {
      await updater.update();
      debugPrint('Shorebird update applied. Restart app to see changes.');
    }

    isLoggedIn = AuthRepository().isLoggedIn();
  } catch (e) {
    isFirebaseInitialized = false;
    errorMessage = e.toString();
    debugPrint('Initialization failed: $e');
  }

  runApp(MyApp(
    isFirebaseInitialized: isFirebaseInitialized,
    isLoggedIn: isLoggedIn,
    errorMessage: errorMessage,
  ));
}
