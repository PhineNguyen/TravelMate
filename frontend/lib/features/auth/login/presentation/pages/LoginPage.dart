import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildWelcomeText(),
                const SizedBox(height: 24),
                _buildLoginForm(),
                const SizedBox(height: 15),
                _buildSocialLogin(),
                const SizedBox(height: 8),
                _buildRegisterLink(),
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
        const Icon(Icons.explore_rounded, color: Colors.blueAccent, size: 36),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Back",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        Text("Sign in to continue planning your world",
            style: TextStyle(fontSize: 15, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("EMAIL ADDRESS"),
        TextFormField(
            decoration: const InputDecoration(
                hintText: "example@email.com", border: OutlineInputBorder())),
        const SizedBox(height: 15),
        _buildLabel("PASSWORD"),
        TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Your password", border: OutlineInputBorder())),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () {}, child: const Text("Forgot password ?")),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size(double.infinity, 54)),
          onPressed: () {},
          child: const Text("Sign in",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey));

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("or continue with")),
            Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Google"))),
            const SizedBox(width: 5),
            Expanded(
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Facebook"))),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No account?",
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        TextButton(
            onPressed: () {},
            child: const Text("Create one",
                style: TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
