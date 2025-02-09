// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meaning_mate/repositories/contact_form_repository.dart';
import 'package:meaning_mate/utils/image.dart';
import 'package:meaning_mate/widgets/text_field.dart';

class ContactPage extends StatelessWidget {
  ContactPage({super.key});

  //controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void sendMessage(BuildContext context) async {
    try {
      ContactService contactService = ContactService();

      await contactService.saveContactMessage(
        emailController.text,
        nameController.text,
        messageController.text,
        context,
      );

      messageController.clear();
      nameController.clear();
      emailController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Failed to send message: $e",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Text(
            e.toString(),
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  //build Main Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 100),
              SvgPicture.asset(
                ContactFormImage.logo,
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 35),
              Text(
                'Meaning Mate',
                style: TextStyle(
                  letterSpacing: .5,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 35),
              CustomTextField(
                controller: nameController,
                hintText: 'Enter your name',
                icon: Icons.person,
                isPassword: false,
              ),
              const SizedBox(height: 35),
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
                icon: Icons.email,
                isPassword: false,
              ),
              const SizedBox(height: 35),
              CustomTextField(
                controller: messageController,
                icon: Icons.message,
                isPassword: false,
                numLines: 5,
                hintText: 'Enter your message',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => sendMessage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
