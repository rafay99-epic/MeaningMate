import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:meaning_mate/repositories/auth_repository.dart';
import 'package:meaning_mate/screens/auth/change_password.dart';
import 'package:meaning_mate/screens/auth/delete_account_screen.dart';
import 'package:meaning_mate/screens/auth/login_screen.dart';
import 'package:meaning_mate/screens/contact_form/contact_form.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

class SettingScreens extends StatefulWidget {
  const SettingScreens({super.key});

  @override
  State<SettingScreens> createState() => _SettingScreensState();
}

class _SettingScreensState extends State<SettingScreens> {
  String appVersion = "Loading...";
  String buildVersion = "Loading...";

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
        buildVersion = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        appVersion = 'Not available';
        buildVersion = 'Not available';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Common Settings Section
          _buildSectionTitle('Common Settings'),
          _buildSettingItem(
            context,
            title: 'Change Password',
            icon: LineIcons.lock,
            onPressed: () {
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
            icon: LineIcons.doorOpen,
            iconColor: Colors.red,
            onPressed: () {
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
          const SizedBox(height: 24),

          // App Info Section
          _buildSectionTitle('App Info'),
          _buildSettingItem(
            context,
            title: 'Environment',
            subtitle: 'Production',
            icon: LineIcons.cloud,
            onPressed: () {},
          ),
          _buildSettingItem(
            context,
            title: 'App Version',
            subtitle: appVersion,
            icon: LineIcons.info,
            onPressed: () {},
          ),
          _buildSettingItem(
            context,
            title: 'App Build Version',
            subtitle: buildVersion,
            icon: LineIcons.codeBranch,
            onPressed: () {},
          ),
          _buildSettingItem(
            context,
            title: 'Contact Form',
            icon: LineIcons.envelope,
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ContactPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Danger Section
          _buildSectionTitle('Danger Zone', isDanger: true),
          _buildSettingItem(
            context,
            title: 'Delete Account',
            icon: LineIcons.trash,
            iconColor: errorColor,
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const DeleteProfile(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.black54,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      splashColor: theme.colorScheme.primary.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDanger ? Colors.red : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
