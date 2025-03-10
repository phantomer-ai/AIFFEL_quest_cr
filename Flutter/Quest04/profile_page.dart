import 'package:flutter/material.dart';
import '../models/user.dart';
import './login_page.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.spa, size: 50)),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('이름'),
                    subtitle: Text(user.name),
                    leading: const Icon(Icons.person_outline),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('이메일'),
                    subtitle: Text(user.email),
                    leading: const Icon(Icons.email_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: 로그아웃 구현
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
