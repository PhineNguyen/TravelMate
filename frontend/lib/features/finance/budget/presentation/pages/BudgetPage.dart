import 'package:flutter/material.dart';
import 'package:frontend/features/finance/expense/presentation/pages/AddExpensePage.dart';

import '../../../../../core/widgets/app_header.dart';

class BudgetPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const BudgetPage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
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
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.more_vert_rounded,
                            color: Color(0xFF1A1D2D), size: 20),
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
          Icon(icon, color: const Color(0xFF1A1D2D), size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Color(0xFF1A1D2D), fontSize: 14)),
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
          color: const Color(0xFF2D7132),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D7132).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.add, size: 18, color: Colors.white),
            SizedBox(width: 6),
            Text(
              "Add",
              style: TextStyle(
                  color: Colors.white,
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
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.2)),
        if (actionText != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132)),
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
      child: Column(
        children: [
          const Text(
            "Total spent — Japan Discovery",
            style: TextStyle(fontSize: 14, color: Color(0xFF71768E)),
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
                        color: const Color(0xFF2D7132).withOpacity(0.5))),
              ),
              const Text("1,842",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D2D))),
            ],
          ),
          const SizedBox(height: 5),
          const Text("of \$4,200 · 26 days remaining",
              style: TextStyle(fontSize: 13, color: Color(0xFFB0B3C1))),
          const SizedBox(height: 40),
          _buildDonutChart(),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Spent", const Color(0xFF2D7132)),
              const SizedBox(width: 20),
              _buildLegendItem("Committed", Colors.teal.shade300),
              const SizedBox(width: 20),
              _buildLegendItem("Remaining", const Color(0xFFF1F4FA)),
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
            backgroundColor: const Color(0xFFF1F4FA),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D7132)),
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
                Colors.teal.shade300.withOpacity(0.6)),
          ),
        ),
        const Column(
          children: [
            Text("44%",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D))),
            Text("used",
                style: TextStyle(fontSize: 12, color: Color(0xFFB0B3C1))),
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
            style: const TextStyle(fontSize: 12, color: Color(0xFF71768E))),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: [
        _buildCategoryItem(Icons.flight, "Flights", "1,200", "1,200", 1.0,
            Colors.deepPurple.shade600),
        _buildCategoryItem(Icons.hotel, "Accommodation", "340", "1,200", 0.28,
            Colors.teal.shade600),
        _buildCategoryItem(Icons.restaurant, "Food & dining", "192", "800",
            0.24, Colors.orange.shade700),
        _buildCategoryItem(Icons.confirmation_number, "Activities", "110",
            "1,000", 0.11, Colors.red.shade600),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String spent,
      String total, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                            color: Color(0xFF1A1D2D))),
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
                          backgroundColor: const Color(0xFFF1F4FA),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text("of \$$total",
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFFB0B3C1))),
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
