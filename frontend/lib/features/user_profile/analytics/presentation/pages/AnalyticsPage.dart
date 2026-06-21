import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class AnalyticsPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const AnalyticsPage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: AppHeader(
                title: "Travel insights",
                onBack: onBackToHome,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSummaryGrid(),
                    const SizedBox(height: 30),
                    _buildSpendingSection(),
                    const SizedBox(height: 30),
                    _buildRegionsSection(),
                    const SizedBox(height: 30),
                    _buildAiAcceptanceSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          "COUNTRIES",
          "24",
          "↑ 2 this year",
          const Color(0xFF1ABC9C),
          Icons.public_rounded,
        ),
        _buildStatCard(
          "DAYS ABROAD",
          "62",
          "↑ 18 vs 2024",
          Colors.blueAccent,
          Icons.calendar_today_rounded,
        ),
        _buildStatCard(
          "TOTAL 2025",
          "\$12.4k",
          "↓ 8% vs 2024",
          Colors.purpleAccent,
          Icons.account_balance_wallet_rounded,
        ),
        _buildStatCard(
          "AI SAVINGS",
          "\$1.2k",
          "vs manual",
          Colors.orangeAccent,
          Icons.auto_awesome_rounded,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String trend,
      Color accentColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.1,
                ),
              ),
              Icon(icon, size: 16, color: accentColor.withOpacity(0.5)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: TextStyle(
              fontSize: 11,
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SPENDING BY MONTH",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar("\$820", 0.3, "Jan", Colors.grey.shade800),
                _buildBar("-", 0.05, "Feb", Colors.grey.shade900),
                _buildBar("\$1.1k", 0.45, "Mar", Colors.teal.shade700),
                _buildBar("\$4.2k", 0.9, "Apr", const Color(0xFF1ABC9C)),
                _buildBar("-", 0.05, "May", Colors.grey.shade900),
                _buildBar("\$2.8k", 0.65, "Jun", Colors.teal.shade800),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
      String value, double heightFactor, String month, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (value != "-")
          Text(
            value,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400),
          ),
        const SizedBox(height: 10),
        Container(
          width: 32,
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          month,
          style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRegionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "REGIONS EXPLORED",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          _buildRegionRow("Asia", 0.8, "9 countries", const Color(0xFF1ABC9C)),
          _buildRegionRow("Europe", 0.7, "8 countries", Colors.blueAccent),
          _buildRegionRow("Americas", 0.4, "5 countries", Colors.purpleAccent),
          _buildRegionRow("Oceania", 0.15, "2 countries", Colors.grey.shade800),
        ],
      ),
    );
  }

  Widget _buildRegionRow(
      String name, double progress, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text(count,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF0B1423),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAcceptanceSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AI ACCEPTANCE RATE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Text(
                "81%",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1ABC9C),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "38 of 47 AI suggestions accepted this year",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                          height: 1.5),
                    ),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.81,
                        backgroundColor: Color(0xFF0B1423),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1ABC9C)),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
