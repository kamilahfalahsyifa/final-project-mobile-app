import 'package:flutter/material.dart';
import 'package:task_hub/auth/login_page.dart';
import 'package:task_hub/page/notification_page.dart';
import 'package:task_hub/services/storage_service.dart';
import 'package:task_hub/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isDarkMode;
  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _isDarkMode = StorageService.getDarkMode();
    final userData = StorageService.getUserData();
    _userName = userData['name'] ?? 'Hustler User';
    _userEmail = userData['email'] ?? 'hustler@mahasiswa.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Center(child: Text(_userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          Center(child: Text(_userEmail, style: const TextStyle(fontSize: 16, color: Colors.grey))),
          const SizedBox(height: 48),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (val) {
                setState(() => _isDarkMode = val);
                StorageService.setDarkMode(val);
                final appState = context.findAncestorStateOfType<TaskHubAppState>();
                appState?.toggleDarkMode();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

