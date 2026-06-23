import 'package:flutter/material.dart';
import 'package:frontend/features/finance/budget/presentation/pages/BudgetPage.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String selectedCategory = 'Flights';
  bool isShared = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add expense",
          style: TextStyle(
            color: Color(0xFF1A1D2D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildAmountDisplayCard(),
            const SizedBox(height: 30),
            _buildSectionTitle("CATEGORY"),
            const SizedBox(height: 15),
            _buildCategoryGrid(),
            const SizedBox(height: 30),
            _buildSectionTitle("AMOUNT"),
            const SizedBox(height: 12),
            _buildTextField(hint: "0.00", keyboardType: TextInputType.number),
            const SizedBox(height: 25),
            _buildSectionTitle("DESCRIPTION (OPTIONAL)"),
            const SizedBox(height: 12),
            _buildTextField(hint: "e.g. Ramen dinner at T's TanTan"),
            const SizedBox(height: 25),
            _buildSectionTitle("DATE"),
            const SizedBox(height: 12),
            _buildTextField(
                hint: "Apr 19, 2025",
                suffixIcon: Icons.calendar_today_outlined),
            const SizedBox(height: 30),
            _buildSharedToggle(),
            const SizedBox(height: 40),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
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
            "AMOUNT",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF71768E),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D7132).withOpacity(0.5),
                  height: 1.6,
                ),
              ),
              const Text(
                "0.00",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF71768E),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final List<Map<String, dynamic>> categories = [
      {
        "name": "Flights",
        "icon": Icons.flight_takeoff_rounded,
        "color": Colors.deepPurple.shade600
      },
      {"name": "Hotel", "icon": Icons.hotel_rounded, "color": Colors.teal.shade600},
      {
        "name": "Food",
        "icon": Icons.restaurant_rounded,
        "color": Colors.orange.shade700
      },
      {
        "name": "Activities",
        "icon": Icons.confirmation_number_rounded,
        "color": Colors.red.shade600
      },
      {"name": "Transport", "icon": Icons.train_rounded, "color": Colors.cyan.shade700},
      {
        "name": "Shopping",
        "icon": Icons.shopping_bag_rounded,
        "color": Colors.pink.shade600
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        bool isSelected = selectedCategory == category['name'];
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = category['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? category['color'].withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? null : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isSelected ? category['color'] : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'],
                    color: isSelected ? category['color'] : const Color(0xFFB0B3C1),
                    size: 26),
                const SizedBox(height: 10),
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? category['color'] : const Color(0xFF71768E),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      {required String hint,
      TextInputType? keyboardType,
      IconData? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        keyboardType: keyboardType,
        style: const TextStyle(color: Color(0xFF1A1D2D)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0B3C1), fontSize: 14),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: const Color(0xFFB0B3C1), size: 20)
              : null,
          contentPadding: const EdgeInsets.all(18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSharedToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          const Icon(Icons.people_outline, color: Color(0xFF2D7132)),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "Shared with collaborators",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1D2D),
              ),
            ),
          ),
          Switch(
            value: isShared,
            onChanged: (value) => setState(() => isShared = value),
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2D7132),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BudgetPage()));
      },
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF2D7132),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D7132).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size: 22, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Save expense",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
