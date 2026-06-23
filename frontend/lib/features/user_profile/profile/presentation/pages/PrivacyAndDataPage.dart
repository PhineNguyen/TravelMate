import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class PrivacyAndDataPage extends StatelessWidget {
  const PrivacyAndDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
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
                  color: Colors.blue.shade700,
                  value: true,
                ),
                _buildToggleItem(
                  icon: Icons.ads_click_outlined,
                  label: "Ad personalization",
                  subtitle: "Show ads relevant to your travel interests.",
                  color: Colors.orange.shade700,
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
                  color: const Color(0xFF2D7132),
                ),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  label: "Clear search history",
                  subtitle: "Remove all previous destination searches.",
                  color: const Color(0xFF71768E),
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("ACCOUNT PRIVACY"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.delete_forever_outlined,
                  label: "Delete account",
                  subtitle: "Permanently remove your account and data.",
                  color: Colors.red.shade600,
                  isDestructive: true,
                ),
              ]),
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Read our full Privacy Policy",
                    style: TextStyle(
                      color: Color(0xFF2D7132),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF2D7132).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Color(0xFF2D7132), size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your privacy matters",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "We encrypt your travel data and never sell it to third parties.",
                  style: TextStyle(color: Color(0xFF71768E), fontSize: 13),
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
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF71768E),
            letterSpacing: 1.2),
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
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF71768E), fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: isDestructive ? Colors.red.shade600 : const Color(0xFFB0B3C1)),
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
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF71768E), fontSize: 12),
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
