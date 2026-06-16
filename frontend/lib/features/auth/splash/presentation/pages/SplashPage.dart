import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: Stack(
          children: [
            ..._buildBackgroundBlobs(),
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEBF1FF), Colors.white],
      ),
    );
  }

  List<Widget> _buildBackgroundBlobs() {
    return [
      Positioned(
        top: -50,
        left: -50,
        child: _buildBlob(250, const Color(0xFFD9E5FF).withOpacity(0.5)),
      ),
      Positioned(
        bottom: 100,
        right: -80,
        child: _buildBlob(200, const Color(0xFFD9E5FF).withOpacity(0.6)),
      ),
      Positioned(
        top: 200,
        right: -20,
        child: _buildBlob(100, const Color(0xFFD9E5FF).withOpacity(0.4)),
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
            _buildLogo(),
            const SizedBox(height: 24),
            _buildAppTitle(),
            const SizedBox(height: 5),
            _buildSlogan(),
            const SizedBox(height: 30),
            _buildPageIndicators(),
            const SizedBox(height: 40),
            _buildGetStartedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D68FF),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D68FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.public_rounded, color: Colors.white, size: 48),
    );
  }

  Widget _buildAppTitle() {
    return const Text(
      "TravelMate",
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40,
        color: Color(0xFF0F172A),
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildSlogan() {
    return const Text(
      "AI-powered travel intelligence",
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDash(true),
        const SizedBox(width: 10),
        _buildDash(false),
      ],
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () {
        // Logic chuyển trang
      },
      child: const Text(
        "Get Started",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDash(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 12,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2D68FF) : const Color(0xFFD1D5DB),
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
