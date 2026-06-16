import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  // Color Palette
  static const Color darkGreen = Color(0xFF0F4D1E);
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color mintGreen = Color(0xFFB6D7A8);
  static const Color paleGreen = Color(0xFFE8F3DC);
  static const Color white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 15),
                _buildSummaryCard(),
                const SizedBox(height: 25),
                _buildSectionHeader("BY CATEGORY", "Add expense"),
                const SizedBox(height: 15),
                _buildCategoryList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Background Gradient (Pale Green -> White)
  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [paleGreen, white],
      ),
    );
  }

  // 2. Header (Dark Green Text, Forest Green Button)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkGreen,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Budget Tracker",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        _buildCircleAddButton(),
      ],
    );
  }

  Widget _buildCircleAddButton() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 18),
        label: const Text("Add"),
        style: ElevatedButton.styleFrom(
          backgroundColor: forestGreen,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // 3. Section Header
  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667085),
                letterSpacing: 1.2)),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: Text(
              actionText,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: forestGreen),
            ),
          ),
      ],
    );
  }

  // 4. Summary Card
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          const Text(
            "Total spent — Japan Discovery",
            style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("\$",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkGreen.withOpacity(0.3))),
              ),
              const Text("1,842",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: darkGreen)),
            ],
          ),
          const Text("of \$4,200 · 26 days remaining",
              style: TextStyle(fontSize: 13, color: Color(0xFF98A2B3))),
          const SizedBox(height: 30),
          _buildDonutChart(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Spent", forestGreen),
              const SizedBox(width: 15),
              _buildLegendItem("Committed", mintGreen),
              const SizedBox(width: 15),
              _buildLegendItem("Remaining", paleGreen),
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
          width: 130,
          height: 130,
          child: CircularProgressIndicator(
            value: 0.44,
            strokeWidth: 14,
            strokeCap: StrokeCap.round,
            backgroundColor: paleGreen,
            valueColor: const AlwaysStoppedAnimation<Color>(forestGreen),
          ),
        ),
        SizedBox(
          width: 130,
          height: 130,
          child: CircularProgressIndicator(
            value: 0.1,
            strokeWidth: 14,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(mintGreen),
          ),
        ),
        Column(
          children: const [
            Text("44%",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: darkGreen)),
            Text("used",
                style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
      ],
    );
  }

  // 5. Category List
  Widget _buildCategoryList() {
    return Column(
      children: [
        _buildCategoryItem(Icons.flight_takeoff_rounded, "Flights", "1,200",
            "1,200", 1.0, forestGreen),
        _buildCategoryItem(Icons.hotel_rounded, "Accommodation", "340", "1,200",
            0.28, mintGreen),
        _buildCategoryItem(Icons.restaurant_rounded, "Food & dining", "192",
            "800", 0.24, forestGreen),
        _buildCategoryItem(Icons.confirmation_number_rounded, "Activities",
            "110", "1,000", 0.11, mintGreen),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String spent,
      String total, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: darkGreen.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
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
                            color: darkGreen)),
                    Text("\$$spent",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreen)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: paleGreen,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text("of \$$total",
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[500])),
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
