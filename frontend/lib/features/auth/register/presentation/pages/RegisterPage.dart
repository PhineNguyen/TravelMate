import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';
import 'package:frontend/features/trip_planning/preferences/presentation/pages/PreferencesPage.dart';

import '../../../../../core/widgets/app_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
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
                    // Chuyển đến trang Preferences sau khi đăng ký thành công
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PreferencesPage()));
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
            color: const Color(0xFF2D7132).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.explore_rounded,
              color: Color(0xFF2D7132), size: 32),
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
              TextSpan(
                  text: "Travel", style: TextStyle(color: Color(0xFF1A1D2D))),
              TextSpan(
                  text: "Mate", style: TextStyle(color: Color(0xFF2D7132))),
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
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D2D)),
        ),
        SizedBox(height: 8),
        Text(
          "Start planning smarter trips today",
          style: TextStyle(fontSize: 16, color: Color(0xFF71768E)),
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
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.1),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            obscureText: isPassword,
            keyboardType: type,
            style: const TextStyle(color: Color(0xFF1A1D2D)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFB0B3C1), fontSize: 14),
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
        const Text("Already have an account?",
            style: TextStyle(fontSize: 14, color: Color(0xFF71768E))),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Text(
            "Sign in",
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2D7132),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
