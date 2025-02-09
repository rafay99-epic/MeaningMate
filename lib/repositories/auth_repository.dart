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
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
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
        await FirebaseFirestore.instance
            .collection('users-database')
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

  // Get the email of the currently logged-in user
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Change password via sending reset link
  Future<void> changePasswordViaEmail(BuildContext context) async {
    try {
      User? user = _auth.currentUser;

      if (user != null && user.email != null) {
        await _auth.sendPasswordResetEmail(email: user.email!);

        _showSuccessDialog(
          context,
          'Password Reset Email Sent',
          'A password reset email has been sent to ${user.email}. Please check your inbox.',
        );
      } else {
        showErrorDialog(context, 'Error', 'No logged-in user found.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e);
      showErrorDialog(context, 'Error', errorMessage);
    } catch (e) {
      showErrorDialog(context, 'Error',
          'An unknown error occurred. Please try again later.');
    }
  }
}
