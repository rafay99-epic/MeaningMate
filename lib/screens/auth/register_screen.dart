import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    super.dispose();
  }

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
                onPressed: () {
                  // Passweord and retype password should be same
                  if (passwordController.text.trim() !=
                      retypePasswordController.text.trim()) {
                    authRepository.showErrorDialog(context, "Password Mismatch",
                        "Passwords do not match. Please try again.");
                    return;
                  }

                  // Handle registration
                  authRepository.register(
                    context,
                    emailController.text,
                    fullNameController.text,
                    passwordController.text,
                    phoneController.text,
                  );

                  // Clear all text fields
                  fullNameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  retypePasswordController.clear();
                  phoneController.clear();

                  SnackBar snackBar = const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      "Registration Successful",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
