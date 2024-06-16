import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DaftarAkunPage extends StatefulWidget {
  const DaftarAkunPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DaftarAkunPageState createState() => _DaftarAkunPageState();
}

class _DaftarAkunPageState extends State<DaftarAkunPage> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    // Validasi email menggunakan RegExp
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Mengecek apakah ada field yang kosong
    if (_namaLengkapController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap semua form diisi!')),
      );
      return;
    }

    // Mengecek format email
    if (!emailRegex.hasMatch(_usernameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    // Mengecek panjang minimal password
    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal harus 6 karakter')),
      );
      return;
    }

    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'full_name': _namaLengkapController.text.trim(),
        'email': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      // Show a success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat')),
      );

      // Navigate back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // Show an error message if registration fails
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 120.0,
                  bottom: 30,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image/logo.png',
                      height: 200,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'DAFTAR AKUN',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _namaLengkapController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'DAFTAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
