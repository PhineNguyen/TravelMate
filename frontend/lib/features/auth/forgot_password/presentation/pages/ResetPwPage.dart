import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/widgets/app_button.dart';

class ResetPwPage extends StatefulWidget {
  const ResetPwPage({super.key});

  @override
  State<ResetPwPage> createState() => _ResetPwPageState();
}

class _ResetPwPageState extends State<ResetPwPage>
    with SingleTickerProviderStateMixin {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 40),
                _buildAnimated3DCard(),
                const SizedBox(height: 40),
                _buildTextContent(),
                const SizedBox(height: 32),
                _buildEmailInputField(),
                const SizedBox(height: 40),
                _buildActionButtons(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildCircleActionIcon(
            Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
        const SizedBox(width: 15),
        const Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
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
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rotateX)
            ..rotateY(_rotateY),
          alignment: FractionalOffset.center,
          child: _build3DCardContent(),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Forgot your password?",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          "Enter your registered email and we'll send you instructions to reset your password. Link expires in 30 minutes.",
          style:
              TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildEmailInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "EMAIL ADDRESS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "example@email.com",
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: "Send Reset Link",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        AppButton(
          label: "Back to sign in",
          onTap: () => Navigator.pop(context),
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _build3DCardContent() {
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
          'assets/Key.json',
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
