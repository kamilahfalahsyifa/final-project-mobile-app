import 'package:flutter/material.dart';
import 'package:task_hub/auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Hustler User', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Text('hustler@mahasiswa.com', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          const SizedBox(height: 48),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
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