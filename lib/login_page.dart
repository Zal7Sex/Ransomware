import 'package:flutter/material.dart';
import 'permissions_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    // Fake loading simulation
    await Future.delayed(const Duration(seconds: 2));
    
    // Auto accept any credentials
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PermissionsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2463),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue[900]!.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/Title
              const Text(
                '🦄 PEGASUS TRASHER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Security Access System',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 40),
              
              // Username Field
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white, fontFamily: 'ShareTechMono'),
                decoration: InputDecoration(
                  labelText: 'USERNAME',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0F3460),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontFamily: 'ShareTechMono'),
                decoration: InputDecoration(
                  labelText: 'PASSWORD',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0F3460),
                ),
              ),
              const SizedBox(height: 30),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login),
                            SizedBox(width: 10),
                            Text(
                              'ACCESS SYSTEM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ShareTechMono',
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text(
                '© Pegasus Security v1.0',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
