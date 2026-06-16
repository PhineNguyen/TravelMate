import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  // Color Palette
  static const Color darkGreen = Color(0xFF0F4D1E);
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color mintGreen = Color(0xFFB6D7A8);
  static const Color paleGreen = Color(0xFFE8F3DC);
  static const Color white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [paleGreen, white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildSummaryGrid(),
                      const SizedBox(height: 25),
                      _buildSpendingSection(),
                      const SizedBox(height: 25),
                      _buildRegionsSection(),
                      const SizedBox(height: 25),
                      _buildAiAcceptanceSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: darkGreen, size: 22),
          ),
          const SizedBox(width: 5),
          const Text(
            "Travel insights",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkGreen,
              letterSpacing: -0.5,
            ),
          ),
        ],
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
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          "COUNTRIES",
          "24",
          "↑ 2 this year",
          paleGreen,
          darkGreen,
          Icons.public_rounded,
        ),
        _buildStatCard(
          "DAYS ABROAD",
          "62",
          "↑ 18 vs 2024",
          const Color(0xFFF3FBEF),
          forestGreen,
          Icons.calendar_today_rounded,
        ),
        _buildStatCard(
          "TOTAL 2025",
          "\$12.4k",
          "↓ 8% vs 2024",
          const Color(0xFFE7F3E1),
          darkGreen,
          Icons.account_balance_wallet_rounded,
        ),
        _buildStatCard(
          "AI SAVINGS",
          "\$1.2k",
          "vs manual",
          const Color(0xFFF9FDF5),
          forestGreen,
          Icons.auto_awesome_rounded,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String trend, Color bgColor,
      Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: bgColor, width: 1.5),
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
                  color: textColor.withOpacity(0.5),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 16, color: textColor.withOpacity(0.3)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SPENDING BY MONTH",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF98A2B3),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar("\$820", 0.3, "Jan", mintGreen),
                _buildBar("-", 0.05, "Feb", paleGreen),
                _buildBar("\$1.1k", 0.45, "Mar", forestGreen),
                _buildBar("\$4.2k", 0.9, "Apr", darkGreen),
                _buildBar("-", 0.05, "May", paleGreen),
                _buildBar("\$2.8k", 0.65, "Jun", forestGreen),
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
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: darkGreen),
          ),
        const SizedBox(height: 8),
        Container(
          width: 35,
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3)),
        ),
      ],
    );
  }

  Widget _buildRegionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "REGIONS EXPLORED",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF98A2B3),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          _buildRegionRow("Asia", 0.8, "9 countries", darkGreen),
          _buildRegionRow("Europe", 0.7, "8 countries", forestGreen),
          _buildRegionRow("Americas", 0.4, "5 countries", mintGreen),
          _buildRegionRow(
              "Oceania", 0.15, "2 countries", mintGreen.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildRegionRow(
      String name, double progress, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475467),
                      fontWeight: FontWeight.w500)),
              Text(count,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: darkGreen)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: paleGreen,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAcceptanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AI ACCEPTANCE RATE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF98A2B3),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "81%",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: forestGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "38 of 47 AI suggestions accepted this year",
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF475467), height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.81,
                        backgroundColor: paleGreen,
                        valueColor: AlwaysStoppedAnimation<Color>(forestGreen),
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
