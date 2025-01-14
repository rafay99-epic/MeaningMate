import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meaning_mate/screens/auth/login_screen.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/utils/sizes.dart';
import 'package:meaning_mate/widgets/text_field.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceCategory = DeviceType.getDeviceCategory(context);

    double spacing;
    EdgeInsetsGeometry padding;
    double logoWidth;

    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        spacing = 20;
        logoWidth = 150;
        padding = const EdgeInsets.symmetric(horizontal: 20);
        break;
      case DeviceCategory.largePhone:
        spacing = 30;
        logoWidth = 200;
        padding = const EdgeInsets.symmetric(horizontal: 40);
        break;
      case DeviceCategory.tablet:
        spacing = 50;
        logoWidth = 300;
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
              SvgPicture.asset(
                RegisterScreenImage.logo,
                width: logoWidth,
              ),

              SizedBox(height: spacing),
              // Full Name TextField
              CustomTextField(
                hintText: "Full Name",
                icon: Icons.person,
                controller: fullNameController,
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
              // Retype Password TextField
              CustomTextField(
                hintText: "Retype Password",
                icon: Icons.lock_outline,
                controller: retypePasswordController,
                isPassword: true,
              ),

              SizedBox(height: spacing),
              // Phone Number TextField
              CustomTextField(
                hintText: "Phone Number",
                icon: Icons.phone,
                controller: phoneController,
                isPassword: true,
              ),

              SizedBox(height: spacing),
              ElevatedButton(
                onPressed: () {
                  // Handle registration
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Register"),
              ),

              SizedBox(height: spacing / 2),
              // Back to Login Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Already have an account? Login",
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
