import 'package:flutter/material.dart';
import 'package:frontend/features/finance/expense/presentation/pages/AddExpensePage.dart';

import '../../../../../core/widgets/app_header.dart';

class BudgetPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const BudgetPage({super.key, this.onBackToHome});

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
                title: "Budget Tracker",
                onBack: onBackToHome,
                trailing: Row(
                  children: [
                    _buildCircleAddButton(context),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      color: const Color(0xFF172234),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      itemBuilder: (context) => [
                        _buildPopupItem(
                            Icons.analytics_outlined, "View reports"),
                        _buildPopupItem(
                            Icons.file_download_outlined, "Export CSV"),
                        _buildPopupItem(
                            Icons.settings_outlined, "Budget limits"),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF172234),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade800),
                        ),
                        child: const Icon(Icons.more_vert_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("BY CATEGORY", "Add expense"),
                    const SizedBox(height: 15),
                    _buildCategoryList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCircleAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1ABC9C),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1ABC9C).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.add, size: 18, color: Color(0xFF0B1423)),
            SizedBox(width: 6),
            Text(
              "Add",
              style: TextStyle(
                  color: Color(0xFF0B1423),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
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
          GestureDetector(
            onTap: () {},
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

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          Text(
            "Total spent — Japan Discovery",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("\$",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1ABC9C).withOpacity(0.5))),
              ),
              const Text("1,842",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 5),
          Text("of \$4,200 · 26 days remaining",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 40),
          _buildDonutChart(),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Spent", const Color(0xFF1ABC9C)),
              const SizedBox(width: 20),
              _buildLegendItem("Committed", Colors.tealAccent.withOpacity(0.4)),
              const SizedBox(width: 20),
              _buildLegendItem("Remaining", const Color(0xFF0B1423)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: 0.44,
            strokeWidth: 16,
            strokeCap: StrokeCap.round,
            backgroundColor: const Color(0xFF0B1423),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1ABC9C)),
          ),
        ),
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: 0.1,
            strokeWidth: 16,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.tealAccent.withOpacity(0.4)),
          ),
        ),
        Column(
          children: [
            const Text("44%",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text("used",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: [
        _buildCategoryItem(Icons.flight, "Flights", "1,200", "1,200", 1.0,
            Colors.deepPurpleAccent),
        _buildCategoryItem(
            Icons.hotel, "Accommodation", "340", "1,200", 0.28, Colors.teal),
        _buildCategoryItem(Icons.restaurant, "Food & dining", "192", "800",
            0.24, Colors.orangeAccent),
        _buildCategoryItem(Icons.confirmation_number, "Activities", "110",
            "1,000", 0.11, Colors.redAccent),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String spent,
      String total, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("\$$spent",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFF0B1423),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text("of \$$total",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
