import 'package:flutter/material.dart';

class ShareTripPage extends StatelessWidget {
  const ShareTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101828)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Share trip",
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Invite friends to view or collaborate on your Japan Discovery trip.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475467),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            _buildQRCodeSection(),
            const SizedBox(height: 20),
            const Text(
              "Or share via invite code",
              style: TextStyle(fontSize: 12, color: Color(0xFF98A2B3)),
            ),
            const SizedBox(height: 15),
            _buildInviteCodeSection(),
            const SizedBox(height: 30),
            _buildSectionHeader("SHARE VIA"),
            const SizedBox(height: 10),
            _buildShareOption(
              icon: Icons.link_rounded,
              label: "Copy link",
              color: const Color(0xFF2D68FF),
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
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader("CURRENT COLLABORATORS"),
            const SizedBox(height: 10),
            _buildCollaboratorItem(
              name: "Alex Johnson",
              role: "Owner",
              initials: "AJ",
              color: const Color(0xFF2D68FF),
              badgeLabel: "Owner",
              badgeColor: const Color(0xFFEEF2FF),
              badgeTextColor: const Color(0xFF2D68FF),
            ),
            const SizedBox(height: 12),
            _buildCollaboratorItem(
              name: "Sarah Kim",
              role: "Collaborator",
              initials: "SK",
              color: const Color(0xFF8B5CF6),
              badgeLabel: "Collab",
              badgeColor: const Color(0xFFF9F5FF),
              badgeTextColor: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      width: 180,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner borders simulation
          _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),
          _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),
          _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
          _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
          Center(
            child: Icon(
              Icons.qr_code_2_rounded,
              size: 100,
              color: const Color(0xFF101828).withOpacity(0.2),
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
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Color(0xFF2D68FF), width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFF2D68FF), width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFF2D68FF), width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFF2D68FF), width: 3)
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TM - 7 K 4 R 2",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828),
              letterSpacing: 1.2,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D68FF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Copy",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
          color: Color(0xFF98A2B3),
          letterSpacing: 1.1,
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101828),
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF98A2B3)),
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Text(
              initials,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
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
                    color: Color(0xFF101828),
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontSize: 10,
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
