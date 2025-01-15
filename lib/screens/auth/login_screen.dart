import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meaning_mate/screens/auth/register_screen.dart';
import 'package:meaning_mate/screens/home/home_screen.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/utils/sizes.dart';
import 'package:meaning_mate/widgets/text_field.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceCategory = DeviceType.getDeviceCategory(context);

    // Adjusting values based on device type
    double logoWidth;
    double spacing;
    EdgeInsetsGeometry padding;

    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        logoWidth = 150;
        spacing = 20;
        padding = const EdgeInsets.symmetric(horizontal: 20);
        break;
      case DeviceCategory.largePhone:
        logoWidth = 200;
        spacing = 30;
        padding = const EdgeInsets.symmetric(horizontal: 40);
        break;
      case DeviceCategory.tablet:
        logoWidth = 300;
        spacing = 50;
        padding = const EdgeInsets.symmetric(horizontal: 80);
        break;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Local Image
              SvgPicture.asset(
                LoginScreenImage.logo,
                width: logoWidth,
              ),

              SizedBox(height: spacing),
              // Email TextField
              CustomTextField(
                hintText: "Email",
                icon: Icons.email,
                controller: emailController,
                isPassword: false,
              ),

              SizedBox(height: spacing),
              // Password TextField
              CustomTextField(
                hintText: "Password",
                icon: Icons.lock,
                controller: passwordController,
                isPassword: true,
              ),

              SizedBox(height: spacing),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      child: const Home(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Login"),
              ),

              SizedBox(height: spacing / 2),
              // Signup Button
              TextButton(
                onPressed: () {
                  // Navigate to Signup
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      child: const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
