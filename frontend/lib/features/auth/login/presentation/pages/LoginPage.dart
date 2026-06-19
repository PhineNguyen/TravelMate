import 'package:flutter/material.dart';
import 'package:frontend/features/auth/forgot_password/presentation/pages/ResetPwPage.dart';
import 'package:frontend/features/auth/register/presentation/pages/RegisterPage.dart';
import 'package:frontend/features/navigation/MainNavigator.dart';

import '../../../../../core/widgets/app_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildWelcomeText(),
              const SizedBox(height: 32),
              _buildLoginForm(context),
              const SizedBox(height: 24),
              _buildSocialLogin(),
              const SizedBox(height: 24),
              _buildRegisterLink(context),
            ],
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

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue planning your world",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("EMAIL ADDRESS"),
        _buildInputField("example@email.com", false),
        const SizedBox(height: 20),
        _buildLabel("PASSWORD"),
        _buildInputField("Your password", true),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResetPwPage()));
            },
            child: const Text(
              "Forgot password ?",
              style: TextStyle(
                  color: Color(0xFF1ABC9C), fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: "Sign in",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigator()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 1.1,
          ),
        ),
      );

  Widget _buildInputField(String hint, bool isPassword) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade800)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "or continue with",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade800)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildSocialButton("Google")),
            const SizedBox(width: 15),
            Expanded(child: _buildSocialButton("Facebook")),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label) {
    return AppButton(
      label: label,
      onTap: () {},
      isPrimary: false,
      height: 54,
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No account?",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: const Text(
            "Create one",
            style: TextStyle(
                color: Color(0xFF1ABC9C), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
