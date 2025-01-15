import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meaning_mate/screens/auth/login_screen.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Meaning Mate",
          body:
              "Discover amazing features to enhance your learning experience.",
          image: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SvgPicture.asset(
              IntroScreenImage.feature1,
              width: 300,
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
            imagePadding: EdgeInsets.zero,
            bodyTextStyle: TextStyle(fontSize: 18, color: Colors.black),
            titleTextStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            bodyPadding: EdgeInsets.all(16),
          ),
        ),
        PageViewModel(
          title: "Learn at Your Own Pace",
          body:
              "Access a wide range of resources tailored to your learning needs.",
          image: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SvgPicture.asset(
              IntroScreenImage.feature2,
              width: 200,
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
            imagePadding: EdgeInsets.zero,
            bodyTextStyle: TextStyle(fontSize: 18, color: Colors.black),
            titleTextStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            bodyPadding: EdgeInsets.all(16),
          ),
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            childBuilder: (context) => const LoginScreen(),
          ),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            childBuilder: (context) => const LoginScreen(),
          ),
        );
      },
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        activeSize: const Size(22.0, 10.0),
        activeColor: theme.colorScheme.primary,
        color: theme.colorScheme.secondary.withOpacity(0.5),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
