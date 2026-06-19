import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const ProfilePage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 40),
              _buildSectionTitle("ACCOUNT"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: "Personal information",
                  color: const Color(0xFF1ABC9C),
                ),
                _buildMenuItem(
                  icon: Icons.favorite_border_rounded,
                  label: "Travel preferences",
                  color: Colors.purpleAccent,
                ),
                _buildMenuItem(
                  icon: Icons.workspace_premium_outlined,
                  label: "Subscription — Pro",
                  color: Colors.orangeAccent,
                  trailingText: "\$12/mo",
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("PREFERENCES"),
              _buildMenuCard([
                _buildToggleItem(
                  icon: Icons.dark_mode_outlined,
                  label: "Dark mode",
                  color: Colors.indigoAccent,
                  value: true,
                ),
                _buildToggleItem(
                  icon: Icons.notifications_none_rounded,
                  label: "Notifications",
                  color: Colors.redAccent,
                  value: true,
                ),
                _buildMenuItem(
                  icon: Icons.translate_rounded,
                  label: "Language",
                  color: Colors.cyanAccent,
                  trailingText: "English",
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("AI & DATA"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.auto_awesome_outlined,
                  label: "AI model",
                  color: Colors.purpleAccent,
                  trailingText: "GPT-4o",
                ),
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  label: "Privacy & data",
                  color: const Color(0xFF1ABC9C),
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart_rounded,
                  label: "Travel analytics",
                  color: Colors.blueAccent,
                ),
              ]),
              const SizedBox(height: 30),
              _buildSectionTitle("SUPPORT"),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  label: "Help centre",
                  color: Colors.blueAccent,
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  label: "Sign out",
                  color: Colors.redAccent,
                  isDestructive: true,
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
        // Thanh điều hướng trên cùng (Back + Title)
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (onBackToHome != null) {
                  onBackToHome!();
                } else {
                  Navigator.maybePop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF172234),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // ✅ ĐÃ HOÀN THIỆN: Bọc Avatar vào GestureDetector để khi bấm vào sẽ kích hoạt popup
        GestureDetector(
          onTap: () => _showProfileSettingsModal(context),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ABC9C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1ABC9C).withOpacity(0.2),
                      blurRadius: 20,
                    )
                  ],
                ),
                child: const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFF172234),
                  child: Text("AJ",
                      style: TextStyle(
                          color: Color(0xFF1ABC9C),
                          fontSize: 34,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Color(0xFF1ABC9C), shape: BoxShape.circle),
                child:
                    const Icon(Icons.check, color: Color(0xFF0B1423), size: 14),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Alex Johnson",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          "Member since Jan 2022 · Pro plan",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge("24 countries", const Color(0xFF1ABC9C)),
            const SizedBox(width: 8),
            _buildBadge("Explorer", Colors.purpleAccent),
            const SizedBox(width: 8),
            _buildBadge("AI power user", Colors.blueAccent),
          ],
        ),
      ],
    );
  }

  // ✅ HÀM MỚI: Xử lý hiển thị cửa sổ lựa chọn (Modal Bottom Sheet) từ dưới trượt lên
  void _showProfileSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF172234),
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh gạch nhỏ định hướng kéo vuốt xuống để đóng nhanh popup
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PROFILE OPTIONS",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildModalItem(
                icon: Icons.account_circle_outlined,
                label: "Edit Profile Info",
                color: const Color(0xFF1ABC9C),
                onTap: () {
                  Navigator.pop(context); // Đóng popup trước khi chuyển trang
                },
              ),
              _buildModalItem(
                icon: Icons.settings_outlined,
                label: "App Settings",
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildModalItem(
                icon: Icons.lock_outline_rounded,
                label: "Change Password",
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Color(0xFF0B1423), height: 30, thickness: 1),
              _buildModalItem(
                icon: Icons.logout_rounded,
                label: "Sign out",
                color: Colors.redAccent,
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ✅ WIDGET PHỤ TRỢ: Tạo nhanh các item dạng danh sách cho popup lựa chọn
  Widget _buildModalItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
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
          color: isDestructive ? Colors.redAccent : Colors.white,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade700),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
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
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.2),
        ),
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
    required Color color,
    String? trailingText,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: () {},
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
          color: isDestructive ? Colors.redAccent : Colors.white,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded,
              color: isDestructive ? Colors.redAccent : Colors.grey.shade700),
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
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
