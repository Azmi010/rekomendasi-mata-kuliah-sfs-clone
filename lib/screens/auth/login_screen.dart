import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
      TextEditingController(); // Untuk Username
  final TextEditingController _passwordController =
      TextEditingController(); // Untuk Password

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Di sini kita asumsikan "Username" adalah Email untuk Firebase Auth
    // Jika Username di aplikasi Anda bukan email, Anda perlu memetakan atau
    // memiliki backend kustom untuk autentikasi username/password.
    // Untuk tujuan demo Firebase Auth, kita akan gunakan sebagai email.
    String email = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Validasi sederhana
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan Password tidak boleh kosong.');
      return;
    }

    String? errorMessage = await authProvider.signIn(email, password);

    if (mounted && errorMessage != null) {
      _showSnackBar(errorMessage);
    }
    // Jika login berhasil, AuthProvider akan otomatis mengubah state user
    // dan Consumer di main.dart akan mengarahkan ke HomeScreen.
  }

  // Fungsi untuk menampilkan SnackBar
  void _showSnackBar(String message) {
    if (mounted) {
      // Tambahkan cek mounted di sini juga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E90FF),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo dan Judul
              Image.asset(
                'assets/img/logo.png',
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'SISTER for Student',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'NEXTGEN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),

              // Input Username
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1E90FF)),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Input Password
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Kata Sandi',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1E90FF)),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),

              // Lupa Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showSnackBar(
                        'Fitur Lupa Password belum diimplementasikan.');
                  },
                  child: const Text(
                    'Lupa Password ?',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Login
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _performLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        );
                },
              ),
              const Spacer(flex: 2),

              // Versi aplikasi
              const Text(
                'versi 3.9.14',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
