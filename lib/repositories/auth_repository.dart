import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meaning_mate/models/user_model.dart';
import 'package:meaning_mate/screens/home/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper method to show success dialog
  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper method to handle Firebase Auth errors
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'email-already-in-use':
        return 'This email is already registered. Please try another.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }

  // Helper method to show error dialog
  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title,
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Check if the user is logged in
  bool isLoggedIn() {
    final user = _auth.currentUser;
    return user != null;
  }

  // Login functionality
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _showSuccessDialog(context, 'Login Successful', 'Login successful!');
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e);
      showErrorDialog(context, 'Login Error', errorMessage);
    } catch (e) {
      showErrorDialog(context, 'Error',
          'An unexpected error occurred. Please try again later.');
    }
  }

  // Logout functionality
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      _showSuccessDialog(context, 'Logout Successful', 'Logout successful!');
    } catch (e) {
      showErrorDialog(
          context, 'Logout Error', 'Failed to logout. Please try again.');
    }
  }

  // Register functionality
  Future<void> register(
    BuildContext context,
    String email,
    String fullName,
    String password,
    String phoneNo,
  ) async {
    try {
      // Create UserModel instance with provided data
      UserModel user = UserModel(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNo,
      );

      // Register user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Save additional user info to Firestore using the UserModel
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'fullName': user.fullName,
          'email': user.email,
          'phoneNo': user.phoneNumber,
        });

        _showSuccessDialog(
            context, 'Registration Successful', 'Welcome, ${user.fullName}!');

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: const Home(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e);
      showErrorDialog(context, 'Registration Failed', errorMessage);
    } catch (e) {
      showErrorDialog(context, 'Error',
          'An unknown error occurred. Please try again later.');
    }
  }
}
