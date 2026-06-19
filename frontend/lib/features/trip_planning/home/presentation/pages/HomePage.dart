import 'package:flutter/material.dart';
import 'package:frontend/features/ai_assistant/chat/presentation/pages/AiChatPage.dart';
import 'package:frontend/features/trip_details/weather/presentation/pages/WeatherPage.dart';
import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripPage.dart';
import 'package:frontend/features/trip_planning/templates/presentation/pages/TemplatesPage.dart';
import 'package:frontend/features/user_profile/notifications/presentation/pages/NotificationsPage.dart';
// ✅ Thêm import trang Profile của bạn (Hãy sửa lại đường dẫn này cho đúng với dự án)
import 'package:frontend/features/user_profile/profile/presentation/pages/ProfilePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildSearchBar(context),
              const SizedBox(height: 30),
              _buildSummaryGrid(),
              const SizedBox(height: 20),
              _buildSectionHeader("QUICK ACTIONS", null),
              const SizedBox(height: 15),
              _buildQuickActions(context),
              const SizedBox(height: 20),
              _buildSectionHeader("CURRENT TRIPS", "See all"),
              const SizedBox(height: 15),
              _buildTripCard(
                "Japan Discovery",
                "Tokyo · Kyoto · Osaka",
                "Apr 12 – May 3  ·  2 pax  ·  \$4,200",
                0.36,
                "Active",
                const Color(0xFF1ABC9C),
              ),
              const SizedBox(height: 15),
              _buildTripCard(
                "Amalfi Weekend",
                "Positano · Ravello · Capri",
                "Jun 18 – 22  ·  4 pax  ·  \$2,800",
                0.0,
                "Upcoming",
                Colors.orangeAccent,
              ),
              const SizedBox(height: 10),
              _buildSectionHeader("WEATHER ALERT", "Details"),
              const SizedBox(height: 10),
              _buildWeatherAlert(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning, traveller",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
            const Text("Alex Johnson",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        // ✅ ĐÃ SỬA: Bọc GestureDetector ngoài cùng và xóa bỏ ElevatedButton bị lỗi bên trong
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1ABC9C), width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF172234),
              child: Text(
                "AJ",
                style: TextStyle(
                  color: Color(0xFF1ABC9C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ✅ ĐÃ SỬA: Thêm kiểu dữ liệu BuildContext chính xác cho tham số truyền vào
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800, width: 0.5),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search destinations...",
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade800, width: 0.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsPage()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: const Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard(
                "ACTIVE TRIPS", "3", "↑ 1 this month", const Color(0xFF1ABC9C)),
            const SizedBox(width: 15),
            _buildStatCard(
                "COUNTRIES", "24", "↑ 2 this year", Colors.purpleAccent),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildStatCard("AI SAVINGS", "\$1.2k", "vs manual booking",
                Colors.orangeAccent),
            const SizedBox(width: 15),
            _buildStatCard("AI PICKS", "47", "81% accepted", Colors.blueAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1.1)),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(sub,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.add, "New trip", const Color(0xFF1ABC9C), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTripPage()));
        }),
        _buildActionItem(
            Icons.grid_view_rounded, "Templates", Colors.tealAccent, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TemplatesPage()));
        }),
        _buildActionItem(
            Icons.smart_toy_outlined, "AI chat", Colors.deepPurpleAccent, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AiChatPage()));
        }),
        _buildActionItem(
            Icons.cloud_queue_rounded, "Weather", Colors.orangeAccent, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WeatherPage()));
        }),
      ],
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, VoidCallback ontap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 80,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: InkWell(
              onTap: ontap,
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: Icon(icon, color: color, size: 28),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildTripCard(String title, String locations, String info,
      double progress, String status, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    _buildStatusBadge(status, themeColor),
                  ],
                ),
                const SizedBox(height: 4),
                Text(locations,
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(info,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
                if (progress > 0) ...[
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFF0B1423),
                        color: themeColor,
                        minHeight: 6),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${(progress * 100).toInt()}% completed",
                          style: TextStyle(
                              fontSize: 10,
                              color: themeColor,
                              fontWeight: FontWeight.bold)),
                      const Text("Day 8 of 22",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeatherAlert() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                  child: Text("Heavy rain — Kyoto Apr 16–17",
                      style: TextStyle(
                          color: Colors.redAccent.shade100,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))),
            ],
          ),
          const SizedBox(height: 5),
          Text("AI has rescheduled 3 outdoor activities automatically.",
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 1.2)),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1ABC9C)),
            ),
          ),
      ],
    );
  }
}
