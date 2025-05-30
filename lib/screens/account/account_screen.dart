import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E90FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ini adalah halaman Akun.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Email: ${authProvider.user?.email ?? 'Tidak ada'}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}