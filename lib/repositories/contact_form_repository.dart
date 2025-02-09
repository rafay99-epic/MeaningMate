// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactService {
  final CollectionReference _contactCollection =
      FirebaseFirestore.instance.collection('contactMessages');

  Future<void> saveContactMessage(
      String email, String name, String message, BuildContext context) async {
    try {
      await _contactCollection.add(
        {
          'email': email,
          'name': name,
          'message': message,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
          showCloseIcon: true,
          closeIconColor: Colors.red,
          duration: const Duration(seconds: 3),
          content: Text(
            'Thank you for the Feedback',
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Failed to send message: $e",
            style: GoogleFonts.roboto(
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
}
