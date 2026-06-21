import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';

import '../../../../../core/widgets/app_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildTitle(),
                const SizedBox(height: 32),
                _buildRegistrationForm(),
                const SizedBox(height: 40),
                AppButton(
                  label: "Create account",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                ),
                const SizedBox(height: 20),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1ABC9C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.explore_rounded,
              color: Color(0xFF1ABC9C), size: 32),
        ),
        const SizedBox(width: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            children: [
              TextSpan(text: "Travel", style: TextStyle(color: Colors.white)),
              TextSpan(
                  text: "Mate", style: TextStyle(color: Color(0xFF1ABC9C))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create account",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Start planning smarter trips today",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("FULL NAME", "Your full name", TextInputType.name),
        const SizedBox(height: 20),
        _buildInputField(
            "EMAIL", "example@email.com", TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildInputField(
            "PASSWORD", "Your password", TextInputType.visiblePassword,
            isPassword: true),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, TextInputType type,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 1.1),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            obscureText: isPassword,
            keyboardType: type,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Text(
            "Sign in",
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF1ABC9C),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
