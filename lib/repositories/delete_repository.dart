import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Deletes the user's word data from Firestore
  Future<void> deleteUserWordData() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      await _firestore.collection('users').doc(user.email).delete();
    } catch (e) {
      throw Exception('Error deleting user word data: $e');
    }
  }

  /// Deletes the user account from Firebase Authentication
  Future<void> deleteUserAccount() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception('Error deleting user account: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting user account: $e');
    }
  }

  /// Main function to delete the user's word data and account, then log out
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Delete word data
      await deleteUserWordData();

      // Delete account
      await deleteUserAccount();

      // Log out the user
      await _auth.signOut();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User account and data deleted successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}
