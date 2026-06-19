import 'package:flutter/material.dart';
import 'package:frontend/features/trip_details/trip_detail/presentation/pages/TripDetailPage.dart';

import '../../../../../core/widgets/app_button.dart';

class TemplatesPage extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TemplatesPage({super.key, this.onBackToHome});

  @override
  State<TemplatesPage> createState() => _TripTemplatesState();
}

class _TripTemplatesState extends State<TemplatesPage> {
  final Set<String> _selectedCategories = {"All"};

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
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildRegionWrap(),
              const SizedBox(height: 30),
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
                color: const Color(0xFF1ABC9C),
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
                color: Colors.orangeAccent,
                bgIcon: Icons.castle_outlined,
              ),
              _buildTemplateCard(
                category: "Adventure",
                usage: "1.2k used",
                title: "Swiss Alps Explorer",
                locations: "Zermatt · Interlaken · Lucerne",
                duration: "7 days",
                pax: "1-2 pax",
                rating: "4.7",
                price: "\$1,950",
                color: Colors.blueAccent,
                bgIcon: Icons.terrain_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.maybePop(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF172234),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 15),
        const Text(
          "Trip Templates",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search Templates, Destinations",
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1ABC9C) : const Color(0xFF172234),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade800,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0B1423) : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 13,
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
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1ABC9C)),
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
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Icon(
                    bgIcon,
                    size: 80,
                    color: color.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1423).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.orangeAccent, size: 16),
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        locations,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSmallInfo(Icons.access_time_rounded, duration),
                    const SizedBox(width: 20),
                    _buildSmallInfo(Icons.people_outline_rounded, pax),
                    const SizedBox(width: 20),
                    _buildSmallInfo(Icons.star_rounded, rating,
                        iconColor: Colors.orangeAccent),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: price,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        children: [
                          TextSpan(
                            text: " est / person",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: AppButton(
                        label: "Use template",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TripDetailPage()));
                        },
                        height: 48,
                      ),
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

  Widget _buildSmallInfo(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
