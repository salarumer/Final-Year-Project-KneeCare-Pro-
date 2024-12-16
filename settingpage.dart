import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import 'signinpage.dart';
import 'aboutpage.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Profile Settings
          _buildSettingItem(context, 'Profile Settings', Icons.person, () {
            // Add your navigation logic here
          }),
          const Divider(),

          // Notification Settings
          _buildSettingItem(context, 'Notification Preferences', Icons.notifications, () {
            // Add your navigation logic here
          }),
          const Divider(),

          // Privacy Settings
          _buildSettingItem(context, 'Privacy Settings', Icons.lock, () {
            // Add your navigation logic here
          }),
          const Divider(),

          // Language Settings
          _buildSettingItem(context, 'Language', Icons.language, () {
            // Add your navigation logic here
          }),
          const Divider(),

          // About the App
          _buildSettingItem(context, 'About App', Icons.info, () {
            // Navigate to AboutScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          }),
          const Divider(),

          // Logout Button
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _logout(context); // Handle logout logic
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Signin()), // Redirect to Sign In page
      );
    } catch (e) {
      // Handle any errors here, e.g., show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }
}
