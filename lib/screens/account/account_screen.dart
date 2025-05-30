import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF1E90FF), // Warna biru
                // Anda bisa menambahkan background image di sini jika ada pattern-nya
                // image: DecorationImage(
                //   image: AssetImage('assets/img/background_pattern.png'), // Asumsikan ada gambar pattern
                //   fit: BoxFit.cover,
                // ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: const Color(0xFF1E90FF)),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    authProvider.user?.email?.split('@')[0].toUpperCase() ?? 'NAMA PENGGUNA',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Text(
                    '222410102068',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section "Program Studi" dan "Fakultas"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Program Studi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E90FF)),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Teknologi Informasi',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const Divider(height: 20),
                    const Text(
                      'Fakultas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E90FF)),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Fakultas Ilmu Komputer',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Menu (Rekam Wajah, Ganti Password, dll.)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildAccountMenuItem(
                      context, Icons.fingerprint, 'Rekam Wajah', () {
                    // TODO: Implementasi rekaman wajah
                  }),
                  _buildAccountMenuItem(
                      context, Icons.lock, 'Ganti Password', () {
                    // TODO: Implementasi ganti password
                  }),
                  _buildAccountMenuItem(
                      context, Icons.description, 'Ketentuan Layanan', () {
                    // TODO: Implementasi ketentuan layanan
                  }),
                  _buildAccountMenuItem(
                      context, Icons.security, 'Kebijakan Privasi', () {
                    // TODO: Implementasi kebijakan privasi
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await authProvider.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun item menu di AccountScreen
  Widget _buildAccountMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1E90FF)), // Ikon biru
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}