import 'package:flutter/material.dart';

class ShareTripPage extends StatelessWidget {
  const ShareTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Share trip",
          style: TextStyle(
            color: Color(0xFF1A1D2D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Invite friends to view or collaborate on your Japan Discovery trip.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF71768E),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            _buildQRCodeSection(),
            const SizedBox(height: 25),
            const Text(
              "Or share via invite code",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB0B3C1),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInviteCodeSection(),
            const SizedBox(height: 40),
            _buildSectionHeader("SHARE VIA"),
            const SizedBox(height: 15),
            _buildShareOption(
              icon: Icons.link_rounded,
              label: "Copy link",
              color: const Color(0xFF2D7132),
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              icon: Icons.phone_android_outlined,
              label: "WhatsApp",
              color: const Color(0xFF12927F),
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              icon: Icons.email_outlined,
              label: "Email invitation",
              color: Colors.deepPurple.shade600,
            ),
            const SizedBox(height: 40),
            _buildSectionHeader("CURRENT COLLABORATORS"),
            const SizedBox(height: 15),
            _buildCollaboratorItem(
              name: "Alex Johnson",
              role: "Owner",
              initials: "AJ",
              color: const Color(0xFF2D7132),
              badgeLabel: "Owner",
              badgeColor: const Color(0xFF2D7132).withOpacity(0.1),
              badgeTextColor: const Color(0xFF2D7132),
            ),
            const SizedBox(height: 12),
            _buildCollaboratorItem(
              name: "Sarah Kim",
              role: "Collaborator",
              initials: "SK",
              color: Colors.deepPurple.shade600,
              badgeLabel: "Collab",
              badgeColor: Colors.deepPurple.shade600.withOpacity(0.1),
              badgeTextColor: Colors.deepPurple.shade600,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),
          _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),
          _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
          _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
          const Center(
            child: Icon(
              Icons.qr_code_2_rounded,
              size: 110,
              color: Color(0xFF1A1D2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(
      {double? top,
      double? bottom,
      double? left,
      double? right,
      required bool isTop,
      required bool isLeft}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Color(0xFF2D7132), width: 4)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFF2D7132), width: 4)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFF2D7132), width: 4)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFF2D7132), width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildInviteCodeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TM - 7 K 4 R 2",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D2D),
              letterSpacing: 1.5,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2D7132),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Copy",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF71768E),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildShareOption(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D2D),
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFB0B3C1)),
        ],
      ),
    );
  }

  Widget _buildCollaboratorItem({
    required String name,
    required String role,
    required String initials,
    required Color color,
    required String badgeLabel,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF71768E),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
