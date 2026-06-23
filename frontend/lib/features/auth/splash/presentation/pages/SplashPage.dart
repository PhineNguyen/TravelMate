import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/auth/onboarding/presentation/pages/OnboardPage.dart';

import '../../../../../core/widgets/app_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
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
        top: -50,
        left: -50,
        child: _buildBlob(350, const Color(0xFFE8EBF5)),
      ),
      Positioned(
        bottom: 100,
        right: -80,
        child: _buildBlob(300, const Color(0xFFE8EBF5)),
      ),
      Positioned(
        bottom: -50,
        left: 20,
        child: _buildBlob(200, const Color(0xFFE8EBF5)),
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
            const SizedBox(height: 40),
            _buildAppTitle(),
            const SizedBox(height: 12),
            _buildSlogan(),
            const Spacer(),
            _buildPageIndicators(),
            const SizedBox(height: 40),
            _buildProgressBar(),
            const SizedBox(height: 40),
            AppButton(
              label: "Get started",
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardPage()));
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
        color: const Color(0xFF6BB04D), // Đồng bộ màu xanh lục tươi
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6BB04D).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.auto_awesome_outlined,
          color: Colors.white, size: 48),
    );
  }

  Widget _buildAppTitle() {
    return const Text(
      "TravelMate",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 42,
        color: Color(0xFF1A1D2D),
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildSlogan() {
    return const Text(
      "Al-powered travel intelligence",
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF71768E),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        const Text(
          "Planning your world...",
          style: TextStyle(
              color: Color(0xFFB0B3C1),
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          width: 160,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color(0xFFE2E4EB),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Row(
              children: [
                Expanded(child: Container(color: const Color(0xFF6BB04D))),
                Expanded(child: Container(color: const Color(0xFF8BC34A))),
                Expanded(child: Container(color: const Color(0xFF29B6F6))),
                Expanded(child: Container(color: const Color(0xFFEF5350))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDash(true),
        const SizedBox(width: 8),
        _buildDash(true),
        const SizedBox(width: 8),
        _buildDash(false),
      ],
    );
  }

  Widget _buildDash(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6BB04D) : const Color(0xFFE2E4EB),
        borderRadius: BorderRadius.circular(3),
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
