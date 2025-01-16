import 'package:flutter/material.dart';
import 'package:meaning_mate/repositories/auth_repository.dart';
import 'package:meaning_mate/screens/auth/change_password.dart';
import 'package:meaning_mate/screens/auth/login_screen.dart';
import 'package:meaning_mate/utils/sizes.dart';
import 'package:page_transition/page_transition.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepository = AuthRepository();
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;
    DeviceCategory deviceCategory = DeviceType.getDeviceCategory(context);

    double fontSize = deviceCategory == DeviceCategory.smallPhone
        ? 14
        : deviceCategory == DeviceCategory.largePhone
            ? 16
            : 18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.surface),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(
            deviceCategory == DeviceCategory.smallPhone ? 16 : 24),
        child: ListView(
          children: [
            // Common Settings Section
            _buildSectionTitle('Common Settings'),
            _buildSettingItem(
              context,
              title: 'Change Password',
              icon: Icons.lock,
              onPressed: () {
                // Navigate to change password page

                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              context,
              title: 'Logout',
              icon: Icons.exit_to_app,
              onPressed: () {
                // Handle logout functionality
                authRepository.logout(context);
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const LoginScreen(),
                  ),
                );
              },
            ),
            const Divider(),

            // App Info Section
            _buildSectionTitle('App Info'),
            _buildSettingItem(
              context,
              title: 'Environment',
              content: Text('Production', style: TextStyle(fontSize: fontSize)),
              icon: Icons.cloud,
              onPressed: () {},
            ),
            _buildSettingItem(
              context,
              title: 'App Version',
              icon: Icons.info,
              content: Text('1.0', style: TextStyle(fontSize: fontSize)),
              onPressed: () {},
            ),
            const Divider(),

            // Danger Section
            _buildSectionTitle('Danger Section'),
            _buildSettingItem(
              context,
              title: 'Delete Account',
              icon: Icons.delete,
              onPressed: () {
                // Navigate to delete account page
              },
              iconColor: errorColor,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each setting item with content and title
  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    Widget? content,
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.black,
  }) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: onSurfaceColor,
            ),
          ),
          const Spacer(),
          content ??
              IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: onPressed,
              ),
        ],
      ),
    );
  }

  // Helper function to build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
