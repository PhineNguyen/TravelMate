import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(), // Đóng gói trang trí nền
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildRegistrationForm(),
                  const SizedBox(height: 15),
                  _buildSubmitButton(),
                  const SizedBox(height: 8),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.explore_rounded, color: Colors.blueAccent, size: 36),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            children: [
              TextSpan(
                  text: "Travel", style: TextStyle(color: Color(0xFF1A1A1A))),
              TextSpan(
                  text: "Mate", style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create account",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          "Start planning smarter trips today",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("FULL NAME", "Your full name", TextInputType.name),
        const SizedBox(height: 15),
        _buildInputField(
            "EMAIL", "example@email.com", TextInputType.emailAddress),
        const SizedBox(height: 15),
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
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: isPassword,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      child: const Text("Create account",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text("Sign in",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
