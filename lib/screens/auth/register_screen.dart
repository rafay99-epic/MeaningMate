import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meaning_mate/repositories/auth_repository.dart';
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
  final emailController = TextEditingController();

  AuthRepository authRepository = AuthRepository();

  @override
  void dispose() {
    fullNameController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceCategory = DeviceType.getDeviceCategory(context);

    double spacing;
    EdgeInsetsGeometry padding;
    double logoWidth;
    double fontSize;

    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        spacing = 20;
        logoWidth = 150;
        padding = const EdgeInsets.symmetric(horizontal: 20);
        fontSize = 18;
        break;
      case DeviceCategory.largePhone:
        spacing = 30;
        logoWidth = 200;
        padding = const EdgeInsets.symmetric(horizontal: 40);
        fontSize = 20;
        break;
      case DeviceCategory.tablet:
        spacing = 50;
        logoWidth = 300;
        padding = const EdgeInsets.symmetric(horizontal: 80);
        fontSize = 22;
        break;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // App Introduction
              Text(
                " Meaning Mate",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Your ultimate app for learning and enhancing vocabulary.",
                style:
                    TextStyle(fontSize: fontSize - 2, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: spacing * 1.5),
              // Logo
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
                isPassword: false,
              ),

              SizedBox(height: spacing),
              ElevatedButton(
                onPressed: () async {
                  // Validate all fields
                  if (fullNameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty) {
                    authRepository.showErrorDialog(
                      context,
                      "Validation Error",
                      "All fields are required",
                    );
                    return;
                  }

                  // Password and retype password should match
                  if (passwordController.text.trim() !=
                      retypePasswordController.text.trim()) {
                    authRepository.showErrorDialog(
                      context,
                      "Password Mismatch",
                      "Passwords do not match. Please try again.",
                    );
                    return;
                  }

                  try {
                    await authRepository.register(
                      context,
                      emailController.text.trim(),
                      fullNameController.text.trim(),
                      passwordController.text.trim(),
                      phoneController.text.trim(),
                    );

                    // Clear fields and show success message only after successful registration
                    fullNameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    retypePasswordController.clear();
                    phoneController.clear();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "Registration Successful",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "Registration failed: ${e.toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              )
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                  elevation: 5, // Add shadow elevation
                  shadowColor: Colors.black
                      .withOpacity(0.4), // Customizable shadow color
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
