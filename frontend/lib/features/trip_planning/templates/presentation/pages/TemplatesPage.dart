import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TripTemplateState();
}

class _TripTemplateState extends State<TemplatePage> {
  final Set<String> _selectedCategories = {};

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
                SizedBox(height: 10),
                _buildSearchBar(),
                SizedBox(height: 10),
                _buildRegionWrap(),
                SizedBox(height: 15),
                _buildSectionHeader("TRENDING THIS WEEK", "View all"),
                const SizedBox(height: 15),
                _buildTemplateCard(
                  category: "Cultural",
                  usage: "2.4k used",
                  title: "Japan Discovery 14D",
                  locations: "Tokyo · Kyoto · Osaka · Hiroshima",
                  duration: "14 days",
                  pax: "2-4 pax",
                  rating: "4.9",
                  price: "\$2,800",
                  color: Colors.blue,
                  bgIcon: Icons.temple_buddhist_outlined,
                ),
                _buildTemplateCard(
                  category: "Culinary",
                  usage: "1.8k used",
                  title: "Paris & Côte d'Azur 10D",
                  locations: "Paris · Nice · Monaco · Cannes",
                  duration: "10 days",
                  pax: "2 pax",
                  rating: "4.8",
                  price: "\$3,200",
                  color: Colors.orange,
                  bgIcon: Icons.castle_outlined,
                ),
                _buildTemplateCard(
                  category: "Culinary",
                  usage: "1.8k used",
                  title: "Paris & Côte d'Azur 10D",
                  locations: "Paris · Nice · Monaco · Cannes",
                  duration: "10 days",
                  pax: "2 pax",
                  rating: "4.8",
                  price: "\$3,200",
                  color: Colors.orange,
                  bgIcon: Icons.castle_outlined,
                ),
                _buildTemplateCard(
                  category: "Culinary",
                  usage: "1.8k used",
                  title: "Paris & Côte d'Azur 10D",
                  locations: "Paris · Nice · Monaco · Cannes",
                  duration: "10 days",
                  pax: "2 pax",
                  rating: "4.8",
                  price: "\$3,200",
                  color: Colors.orange,
                  bgIcon: Icons.castle_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF101828),
            size: 24,
          ),
        ),
        SizedBox(width: 10),
        const Text(
          "Trip Templates",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101828),
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            //logic here
          },
          icon: const Icon(
            Icons.tune_rounded,
            color: Colors.black,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Search Templates, Destinations",
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRegionWrap() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildCategoriesChip("All"),
          _buildCategoriesChip("Culinary"),
          _buildCategoriesChip("Beach"),
          _buildCategoriesChip("Luxury"),
          _buildCategoriesChip("Budget"),
          _buildCategoriesChip("Nature"),
          _buildCategoriesChip("Culture"),
        ],
      ),
    );
  }

  Widget _buildCategoriesChip(String label) {
    bool isSelected = _selectedCategories.contains(label);
    return GestureDetector(
      onTap: () => setState(() => isSelected
          ? _selectedCategories.remove(label)
          : _selectedCategories.add(label)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
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

  Widget _buildTemplateCard({
    required String category,
    required String usage,
    required String title,
    required String locations,
    required String duration,
    required String pax,
    required String rating,
    required String price,
    required Color color,
    required IconData bgIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ====HEADER
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), // Màu nền nhạt
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Icon(
                    bgIcon,
                    size: 80,
                    color: color.withOpacity(0.2),
                  ),
                ),
              ),
              // Category (Cultural/Culinary...) label
              Positioned(
                top: 12,
                left: 12,
                child: Text(
                  category,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              // Nhãn Usage (Số người dùng)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.white, size: 17),
                      const SizedBox(width: 4),
                      Text(
                        usage,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- information details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locations,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //infor, time
                Row(
                  children: [
                    _buildSmallInfo(Icons.access_time_rounded, duration),
                    const SizedBox(width: 15),
                    _buildSmallInfo(Icons.people_outline_rounded, pax),
                    const SizedBox(width: 15),
                    _buildSmallInfo(Icons.star_rounded, rating,
                        iconColor: Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),
                // price, button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: price,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF101828)),
                        children: [
                          TextSpan(
                            text: " est / person",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D68FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      child: const Text("Use template",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Hàm phụ để tạo các icon-text nhỏ (14 days, 2-4 pax...)
  Widget _buildSmallInfo(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[400]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }
}
