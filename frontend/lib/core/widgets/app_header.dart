import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? trailing;
  final List<Widget>? bottom;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBackButton)
              GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Color(0xFF1A1D2D), size: 20),
                ),
              ),
            if (showBackButton) const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2D),
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (bottom != null) ...[
          const SizedBox(height: 25),
          ...bottom!,
        ],
      ],
    );
  }
}
