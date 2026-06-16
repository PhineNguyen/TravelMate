import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(), // Gradient nền đồng bộ
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildSectionTitle("ACCOUNT"),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: "Personal information",
                    color: const Color(0xFF2D68FF),
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_border_rounded,
                    label: "Travel preferences",
                    color: const Color(0xFF8B5CF6),
                  ),
                  _buildMenuItem(
                    icon: Icons.workspace_premium_outlined,
                    label: "Subscription — Pro",
                    color: const Color(0xFFD97706),
                    trailingText: "\$12/mo",
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionTitle("PREFERENCES"),
                _buildMenuCard([
                  _buildToggleItem(
                    icon: Icons.dark_mode_outlined,
                    label: "Dark mode",
                    color: const Color(0xFF6366F1),
                    value: false,
                  ),
                  _buildToggleItem(
                    icon: Icons.notifications_none_rounded,
                    label: "Notifications",
                    color: const Color(0xFFD92D20),
                    value: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.translate_rounded,
                    label: "Language",
                    color: const Color(0xFF94A3B8),
                    trailingText: "English",
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionTitle("AI & DATA"),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.auto_awesome_outlined,
                    label: "AI model",
                    color: const Color(0xFF8B5CF6),
                    trailingText: "GPT-4o",
                  ),
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    label: "Privacy & data",
                    color: const Color(0xFF12927F),
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    label: "Travel analytics",
                    color: const Color(0xFF2D68FF),
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSectionTitle("SUPPORT"),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: "Help centre",
                    color: const Color(0xFF2D68FF),
                  ),
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    label: "Sign out",
                    color: const Color(0xFFD92D20),
                    isDestructive: true,
                  ),
                ]),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Background Gradient đồng bộ
  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  // 2. Header với Avatar và Badges
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF2D68FF),
                child: Text("AJ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: Color(0xFF12927F), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            )
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          "Alex Johnson",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828)),
        ),
        const Text(
          "Member since Jan 2022 · Pro plan",
          style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge("24 countries", const Color(0xFF2D68FF)),
            const SizedBox(width: 8),
            _buildBadge("Explorer", const Color(0xFF8B5CF6)),
            const SizedBox(width: 8),
            _buildBadge("AI power user", const Color(0xFF12927F)),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  // 3. Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2),
        ),
      ),
    );
  }

  // 4. Menu Card bọc ngoài các item
  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(children: items),
    );
  }

  // 5. Menu Item
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    String? trailingText,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color:
              isDestructive ? const Color(0xFFD92D20) : const Color(0xFF101828),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              color:
                  isDestructive ? const Color(0xFFD92D20) : Colors.grey[400]),
        ],
      ),
    );
  }

  // 6. Toggle Item
  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required Color color,
    required bool value,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101828)),
      ),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: const Color(0xFF2D68FF),
      ),
    );
  }
}
