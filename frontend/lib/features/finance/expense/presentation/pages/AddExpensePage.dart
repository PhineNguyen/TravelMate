import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101828)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add expense",
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildAmountDisplayCard(),
            const SizedBox(height: 25),
            _buildSectionTitle("CATEGORY"),
            const SizedBox(height: 15),
            _buildCategoryGrid(),
            const SizedBox(height: 25),
            _buildSectionTitle("AMOUNT"),
            const SizedBox(height: 10),
            _buildTextField(hint: "0.00", keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildSectionTitle("DESCRIPTION (OPTIONAL)"),
            const SizedBox(height: 10),
            _buildTextField(hint: "e.g. Ramen dinner at T's TanTan"),
            const SizedBox(height: 20),
            _buildSectionTitle("DATE"),
            const SizedBox(height: 10),
            _buildTextField(
                hint: "Apr 19, 2025",
                suffixIcon: Icons.calendar_today_outlined),
            const SizedBox(height: 25),
            _buildSharedToggle(),
            const SizedBox(height: 30),
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
      ),
      child: Column(
        children: [
          const Text(
            "AMOUNT",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF98A2B3),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828).withOpacity(0.3),
                  height: 1.6,
                ),
              ),
              const Text(
                "0.00",
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF98A2B3),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final List<Map<String, dynamic>> categories = [
      {
        "name": "Flights",
        "icon": Icons.flight_takeoff_rounded,
        "color": const Color(0xFF2D68FF)
      },
      {
        "name": "Hotel",
        "icon": Icons.hotel_rounded,
        "color": const Color(0xFF8B5CF6)
      },
      {
        "name": "Food",
        "icon": Icons.restaurant_rounded,
        "color": const Color(0xFF12927F)
      },
      {
        "name": "Activities",
        "icon": Icons.confirmation_number_rounded,
        "color": const Color(0xFFD92D20)
      },
      {
        "name": "Transport",
        "icon": Icons.train_rounded,
        "color": const Color(0xFFD97706)
      },
      {
        "name": "Shopping",
        "icon": Icons.shopping_bag_rounded,
        "color": const Color(0xFFE91E63)
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        bool isSelected = selectedCategory == category['name'];
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = category['name']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: const Color(0xFF2D68FF), width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], color: category['color'], size: 24),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2D68FF)
                        : const Color(0xFF667085),
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
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: const Color(0xFF98A2B3), size: 20)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEAECF0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D68FF)),
        ),
      ),
    );
  }

  Widget _buildSharedToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_outline, color: Color(0xFF667085)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Shared with collaborators",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF101828),
              ),
            ),
          ),
          Switch(
            value: isShared,
            onChanged: (value) => setState(() => isShared = value),
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2D68FF),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check, size: 20),
        label: const Text(
          "Save expense",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12927F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
