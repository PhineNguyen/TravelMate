import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';
import 'package:frontend/features/auth/register/presentation/pages/RegisterPage.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/widgets/app_button.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage>
    with SingleTickerProviderStateMixin {
  // --- STATE VARIABLES ---
  double _rotateX = 0;
  double _rotateY = 0;

  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationX = const AlwaysStoppedAnimation(0.0);
    _animationY = const AlwaysStoppedAnimation(0.0);

    _controller.addListener(() {
      setState(() {
        _rotateX = _animationX.value;
        _rotateY = _animationY.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetRotation() {
    _animationX = Tween<double>(begin: _rotateX, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _animationY = Tween<double>(begin: _rotateY, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildAnimated3DCard(),
              const SizedBox(height: 40),
              _buildTextContent(),
              const SizedBox(height: 50),
              _buildActionButtons(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimated3DCard() {
    return GestureDetector(
      onPanUpdate: (details) {
        _controller.stop();
        setState(() {
          _rotateY += details.delta.dx * 0.01;
          _rotateX -= details.delta.dy * 0.01;
        });
      },
      onPanEnd: (details) => _resetRotation(),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_rotateX)
          ..rotateY(_rotateY),
        alignment: FractionalOffset.center,
        child: _buildCardUI(),
      ),
    );
  }

  Widget _buildCardUI() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color(0xFF1ABC9C).withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1ABC9C).withOpacity(0.05),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Lottie.asset(
          'assets/onboard.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        const Text(
          "Intelligent itineraries, instantly",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Describe your dream trip in plain language. Our AI builds a complete, colour-coded itinerary in seconds - with local insights you won't find in a guidebook.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          label: "Get started",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
        ),
        const SizedBox(height: 16),
        AppButton(
          label: "Sign in to existing account",
          isPrimary: false,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        ),
      ],
    );
  }
}
