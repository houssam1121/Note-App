import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Sign up to get started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await authViewModel.signUpWithEmail(
                          emailController.text, passwordController.text);
                      Navigator.of(context).pushNamed("login");
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6A11CB),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed("login"),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}