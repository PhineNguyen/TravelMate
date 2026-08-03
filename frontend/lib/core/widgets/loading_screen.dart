import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({
    super.key,
    this.message = "AI is thinking...",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF2D7132),
              strokeWidth: 3,
            ),
            const SizedBox(height: 32),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D2D),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "This may take a few seconds",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF71768E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
