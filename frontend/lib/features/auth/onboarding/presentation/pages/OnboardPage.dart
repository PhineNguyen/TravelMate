import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

    // Khởi tạo giá trị mặc định để tránh lỗi 'late initialization'
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildAnimated3DCard(), // 1. Khối card 3D
                const SizedBox(height: 30),
                _buildTextContent(), // 2. Khối nội dung văn bản
                const SizedBox(height: 40),
                _buildActionButtons(), // 3. Khối các nút bấm
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  Widget _buildAnimated3DCard() {
    return GestureDetector(
      onPanUpdate: (details) {
        _controller.stop();
        setState(() {
          // SỬA LỖI TRỤC XOAY: dx xoay quanh Y, dy xoay quanh X
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
      aspectRatio: 21 / 11.8,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 30,
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
            fontSize: 28,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Describe your dream trip in plain language. Our AI builds a complete, colour-coded itinerary in seconds - with local insights you won't find in a guidebook.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildAppButton(
          label: "Get started",
          onPressed: () {},
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildAppButton(
          label: "Sign in to existing account",
          onPressed: () {},
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildAppButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blueAccent : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
        elevation: isPrimary ? 4 : 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
