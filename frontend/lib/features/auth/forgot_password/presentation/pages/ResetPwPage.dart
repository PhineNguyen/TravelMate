import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPwPage extends StatefulWidget {
  const ResetPwPage({super.key});

  @override
  State<ResetPwPage> createState() => _ResetPwPageState();
}

class _ResetPwPageState extends State<ResetPwPage>
    with SingleTickerProviderStateMixin {
  // Biến lưu trữ giá trị xoay
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

    // Khởi tạo giá trị mặc định để tránh lỗi late initialization
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
            // Thêm để tránh lỗi tràn màn hình khi hiện bàn phím
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  _buildAnimated3DCard(),
                  const SizedBox(height: 20),
                  _buildTextContent(),
                  const SizedBox(height: 30),
                  _buildEmailInputField(),
                  const SizedBox(height: 30),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. Trang trí nền Gradient
  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  // 2. Header: Nút quay lại và Tiêu đề
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildCircleActionIcon(
            Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
        const SizedBox(width: 5),
        const Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101828),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  // 3. Khối hình ảnh 3D tương tác
  Widget _buildAnimated3DCard() {
    return GestureDetector(
      onPanUpdate: (details) {
        _controller.stop();
        setState(() {
          // Sửa logic xoay: Vuốt ngang (dx) xoay quanh trục Y, vuốt dọc (dy) xoay quanh trục X
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

  // 4. Nội dung text tiêu đề và mô tả
  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Forgot your password?",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter your registered email and we'll send you instructions to reset your password. Link expires in 30 minutes.",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  // 5. Ô nhập liệu Email
  Widget _buildEmailInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EMAIL ADDRESS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "example@email.com",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white70,
          ),
        ),
      ],
    );
  }

  // 6. Các nút bấm hành động
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          label: "Send Reset Link",
          onPressed: () {},
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildButton(
          label: "Back to sign in",
          onPressed: () => Navigator.pop(context),
          isPrimary: false,
        ),
      ],
    );
  }

  // Hàm dùng chung để tạo Button
  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blueAccent : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.grey[600],
        minimumSize: const Size(double.infinity, 54),
        elevation: isPrimary ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF475467), size: 22),
      ),
    );
  }

  // Nội dung tấm thẻ Lottie
  Widget _build3DCardContent() {
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
          'assets/Key.json',
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
