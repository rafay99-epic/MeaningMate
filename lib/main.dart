import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meaning_mate/firebase_options.dart';
import 'package:meaning_mate/screens/errorhandelling/errorHandelling.dart';
import 'package:meaning_mate/screens/splash/splash_screen.dart';
import 'package:meaning_mate/utils/colors.dart';

class MyApp extends StatelessWidget {
  final bool isFirebaseInitialized;
  final String? errorMessage;

  const MyApp({
    super.key,
    required this.isFirebaseInitialized,
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

    return MaterialApp(
      theme: basecolors,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseInitialized = false;
  String? errorMessage;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
  } catch (e) {
    isFirebaseInitialized = false;
    errorMessage = e.toString();
  }

  runApp(MyApp(
    isFirebaseInitialized: isFirebaseInitialized,
    errorMessage: errorMessage,
  ));
}
