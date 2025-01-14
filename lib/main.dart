import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meaning_mate/firebase_options.dart';
import 'package:meaning_mate/screens/splash/splash_screen.dart';
import 'package:meaning_mate/utils/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basecolors,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
