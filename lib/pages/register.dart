import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    final auth = AuthService();
    final success = await auth.register(email, password);

    if (success) {
      Navigator.pop(context); // Kembali ke halaman login
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('An error occurred during registration.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _register(context), child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
