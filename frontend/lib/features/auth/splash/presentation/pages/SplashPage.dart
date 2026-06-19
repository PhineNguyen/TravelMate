import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: Stack(
        children: [
          ..._buildBackgroundBlobs(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundBlobs() {
    return [
      Positioned(
        top: -100,
        left: -50,
        child: _buildBlob(300, const Color(0xFF1ABC9C).withOpacity(0.05)),
      ),
      Positioned(
        bottom: 50,
        right: -100,
        child: _buildBlob(250, const Color(0xFF1ABC9C).withOpacity(0.08)),
      ),
    ];
  }

  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildLogo(),
            const SizedBox(height: 30),
            _buildAppTitle(),
            const SizedBox(height: 8),
            _buildSlogan(),
            const Spacer(),
            _buildPageIndicators(),
            const SizedBox(height: 40),
            AppButton(
              label: "Get Started",
              onTap: () {
                // Navigation logic
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1ABC9C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: const Color(0xFF1ABC9C).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1ABC9C).withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child:
          const Icon(Icons.public_rounded, color: Color(0xFF1ABC9C), size: 64),
    );
  }

  Widget _buildAppTitle() {
    return const Text(
      "TravelMate",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 42,
        color: Colors.white,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildSlogan() {
    return Text(
      "AI-powered travel intelligence",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDash(true),
        const SizedBox(width: 8),
        _buildDash(false),
        const SizedBox(width: 8),
        _buildDash(false),
      ],
    );
  }

  Widget _buildDash(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 8,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1ABC9C) : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
