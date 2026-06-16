import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildSummaryGrid(),
              const SizedBox(height: 25),
              _buildSectionHeader("QUICK ACTIONS", null),
              const SizedBox(height: 15),
              _buildQuickActions(),
              const SizedBox(height: 25),
              _buildSectionHeader("CURRENT TRIPS", "See all"),
              const SizedBox(height: 15),
              _buildTripCard(
                "Japan Discovery",
                "Tokyo · Kyoto · Osaka",
                "Apr 12 – May 3  ·  2 pax  ·  \$4,200",
                0.36,
                "Active",
                const Color(0xFF2D68FF),
              ),
              const SizedBox(height: 10),
              _buildTripCard(
                "Amalfi Weekend",
                "Positano · Ravello · Capri",
                "Jun 18 – 22  ·  4 pax  ·  \$2,800",
                0.0,
                "Upcoming",
                Colors.orange,
              ),
              const SizedBox(height: 15),
              _buildSectionHeader("WEATHER ALERT", "Details"),
              const SizedBox(height: 15),
              _buildWeatherAlert(),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. HEADER (Tên người dùng + Avatar) ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning, traveller",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const Text("Alex Johnson",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101828))),
          ],
        ),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF2D68FF),
          child: Text("AJ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search destinations...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Icon(Icons.notifications_none_rounded,
            size: 30, color: Color(0xFF101828)),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard("ACTIVE TRIPS", "3", "↑ 1 this month", Colors.blue),
            const SizedBox(width: 15),
            _buildStatCard("COUNTRIES", "24", "↑ 2 this year", Colors.purple),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildStatCard(
                "AI SAVINGS", "\$1.2k", "vs manual booking", Colors.green),
            const SizedBox(width: 15),
            _buildStatCard("AI PICKS", "47", "81% accepted", Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(sub,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  // --- 4. QUICK ACTIONS (Nút bấm liên kết) ---
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.add, "New trip", Colors.blue),
        _buildActionItem(Icons.grid_view_rounded, "Templates", Colors.teal),
        _buildActionItem(
            Icons.smart_toy_outlined, "AI chat", Colors.deepPurple),
        _buildActionItem(Icons.cloud_queue_rounded, "Weather", Colors.red),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min, // chỉ lấy diện tích cần thiết
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: color.withOpacity(0.2), //shadow theo màu của icon
          child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                //logic here
              },
              //effect
              child: SizedBox(
                  height: 60,
                  width: double.infinity, //lắp đầy expanded
                  child: Icon(
                    icon,
                    color: color,
                    size: 26,
                  ))),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // --- 5. TRIP CARD (Thẻ chuyến đi) ---
  Widget _buildTripCard(String title, String locations, String info,
      double progress, String status, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Container(
              height: 4,
              decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)))),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildStatusBadge(status, themeColor),
                  ],
                ),
                Text(locations,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Text(info,
                    style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                if (progress > 0) ...[
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[100],
                      color: themeColor,
                      minHeight: 6),
                  const SizedBox(height: 5),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text("Day 8 of 22 - ${(progress * 100).toInt()}%",
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey))),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // --- 6. WEATHER ALERT ---
  Widget _buildWeatherAlert() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                  child: Text("Heavy rain — Kyoto Apr 16–17",
                      style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 5),
          Text("AI has rescheduled 3 outdoor activities automatically.",
              style: TextStyle(color: Colors.red[700], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2)),
        if (actionText != null)
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {},
            child: Text(
              actionText,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent),
            ),
          ),
      ],
    );
  }
}
