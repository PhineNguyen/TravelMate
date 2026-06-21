import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class PrivacyAndDataPage extends StatelessWidget {
  const PrivacyAndDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: "Privacy & Data",
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 30),
              _buildInfoBox(),
              const SizedBox(height: 40),
              _buildSectionTitle("DATA USAGE"),
              _buildMenuCard([
                _buildToggleItem(
                  icon: Icons.analytics_outlined,
                  label: "Personalized experiences",
                  subtitle: "Use my travel history to improve AI suggestions.",
                  color: Colors.blueAccent,
                  value: true,
                ),
                _buildToggleItem(
                  icon: Icons.ads_click_outlined,
                  label: "Ad personalization",
                  subtitle: "Show ads relevant to your travel interests.",
                  color: Colors.orangeAccent,
                  value: false,
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("YOUR DATA"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.download_outlined,
                  label: "Export your data",
                  subtitle: "Get a copy of your trips and profile info.",
                  color: const Color(0xFF1ABC9C),
                ),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  label: "Clear search history",
                  subtitle: "Remove all previous destination searches.",
                  color: Colors.grey,
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("ACCOUNT PRIVACY"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.delete_forever_outlined,
                  label: "Delete account",
                  subtitle: "Permanently remove your account and data.",
                  color: Colors.redAccent,
                  isDestructive: true,
                ),
              ]),
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Read our full Privacy Policy",
                    style: TextStyle(
                      color: const Color(0xFF1ABC9C),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF1ABC9C).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Color(0xFF1ABC9C), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your privacy matters",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "We encrypt your travel data and never sell it to third parties.",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.redAccent : Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: isDestructive ? Colors.redAccent : Colors.grey.shade700),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required bool value,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF1ABC9C),
      ),
    );
  }
}
