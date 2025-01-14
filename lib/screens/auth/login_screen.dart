import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // local Image
            SvgPicture.asset(
              LoginScreenImage.logo,
              width: 200,
            ),

            // Email TextField
            CustomTextField(
              hintText: "Email",
              icon: Icons.email,
              controller: emailController,
              isPassword: false,
            ),
            const SizedBox(height: 20),
            // Password TextField
            CustomTextField(
              hintText: "Password",
              icon: Icons.lock,
              controller: passwordController,
              isPassword: true,
            ),

            // Pasword TextField

            // Login Button
            // Signup Button
          ],
        ),
      ),
    );
  }
}
