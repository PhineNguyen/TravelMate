import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final Widget? icon;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isPrimary = true,
    this.icon,
    this.height = 58,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1ABC9C) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isPrimary ? null : Border.all(color: Colors.grey.shade800),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF1ABC9C).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? const Color(0xFF0B1423) : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
