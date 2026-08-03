import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';
import 'package:frontend/features/user_profile/profile/presentation/pages/HelpCentrePage.dart';
import 'package:frontend/features/user_profile/profile/presentation/pages/PersonalInformationPage.dart';
import 'package:frontend/features/user_profile/profile/presentation/pages/PrivacyAndDataPage.dart';

import '../../../../../core/widgets/app_header.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const ProfilePage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              AppHeader(
                title: "Profile",
                onBack: onBackToHome,
              ),
              const SizedBox(height: 30),
              _buildHeader(context),
              const SizedBox(height: 40),
              _buildSectionTitle("ACCOUNT"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: "Personal information",
                  color: const Color(0xFF2D7132),
                  context: context,
                  page: const PersonalInformationPage(),
                ),
                _buildMenuItem(
                  icon: Icons.favorite_border_rounded,
                  label: "Travel preferences",
                  color: Colors.purple.shade600,
                ),
                _buildMenuItem(
                  icon: Icons.workspace_premium_outlined,
                  label: "Subscription — Pro",
                  color: Colors.orange.shade700,
                  trailingText: "\$12/mo",
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("PREFERENCES"),
              _buildMenuCard([
                _buildToggleItem(
                  icon: Icons.dark_mode_outlined,
                  label: "Dark mode",
                  color: Colors.indigo.shade600,
                  value: false,
                ),
                _buildToggleItem(
                  icon: Icons.notifications_none_rounded,
                  label: "Notifications",
                  color: Colors.red.shade600,
                  value: true,
                ),
                _buildMenuItem(
                  icon: Icons.translate_rounded,
                  label: "Language",
                  color: Colors.cyan.shade700,
                  trailingText: "English",
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("AI & DATA"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.auto_awesome_outlined,
                  label: "AI model",
                  color: Colors.purple.shade600,
                  trailingText: "GPT-4o",
                ),
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  label: "Privacy & data",
                  color: const Color(0xFF2D7132),
                  context: context,
                  page: const PrivacyAndDataPage(),
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart_rounded,
                  label: "Travel analytics",
                  color: Colors.blue.shade700,
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("SUPPORT"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  label: "Help centre",
                  color: Colors.blue.shade700,
                  context: context,
                  page: const HelpCentrePage(),
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  label: "Sign out",
                  color: Colors.red.shade600,
                  isDestructive: true,
                  context: context,
                  page: const LoginPage(),
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFF2D7132),
                child: Text("AJ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: const Color(0xFF1ABC9C),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Alex Johnson",
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D2D)),
        ),
        const SizedBox(height: 6),
        const Text(
          "Member since Jan 2022 · Pro plan",
          style: TextStyle(fontSize: 14, color: Color(0xFF71768E)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge("24 countries", const Color(0xFF2D7132)),
            const SizedBox(width: 8),
            _buildBadge("Explorer", Colors.purple.shade600),
            const SizedBox(width: 8),
            _buildBadge("AI power user", Colors.blue.shade700),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF71768E),
              letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    BuildContext? context,
    Widget? page,
    String? trailingText,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: page != null
          ? () => Navigator.push(
                context!,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red.shade600 : const Color(0xFF1A1D2D),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF71768E),
                    fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded,
              color: isDestructive
                  ? Colors.red.shade600
                  : const Color(0xFFB0B3C1)),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required Color color,
    required bool value,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1D2D)),
      ),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF2D7132),
      ),
    );
  }
}
