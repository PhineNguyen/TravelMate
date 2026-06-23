import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class HelpCentrePage extends StatelessWidget {
  const HelpCentrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: "Help Centre",
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 30),
              _buildSearchBar(),
              const SizedBox(height: 40),
              _buildSectionTitle("TOP TOPICS"),
              _buildTopicGrid(),
              const SizedBox(height: 40),
              _buildSectionTitle("FREQUENTLY ASKED QUESTIONS"),
              _buildFAQList(),
              const SizedBox(height: 40),
              _buildContactSupport(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      child: const TextField(
        style: TextStyle(color: Color(0xFF1A1D2D)),
        decoration: InputDecoration(
          hintText: "Search for help...",
          hintStyle: TextStyle(color: Color(0xFFB0B3C1), fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFF2D7132)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF71768E),
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTopicGrid() {
    final topics = [
      {'icon': Icons.person_outline, 'label': 'Account'},
      {'icon': Icons.map_outlined, 'label': 'Trips'},
      {'icon': Icons.payment_outlined, 'label': 'Payments'},
      {'icon': Icons.auto_awesome_outlined, 'label': 'AI Help'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(topics[index]['icon'] as IconData,
                  color: const Color(0xFF2D7132), size: 28),
              const SizedBox(height: 12),
              Text(
                topics[index]['label'] as String,
                style: const TextStyle(
                    color: Color(0xFF1A1D2D),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFAQList() {
    final faqs = [
      "How to plan a trip with AI?",
      "Can I share my itinerary with friends?",
      "How to export my expenses?",
      "Updating my subscription",
    ];

    return Container(
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
      child: Column(
        children: faqs.map((faq) {
          return Column(
            children: [
              ListTile(
                title: Text(faq,
                    style: const TextStyle(
                        color: Color(0xFF1A1D2D), fontSize: 14)),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFB0B3C1)),
                onTap: () {},
              ),
              if (faq != faqs.last)
                const Divider(color: Color(0xFFF1F4FA), height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Still need help?",
                  style: TextStyle(
                      color: Color(0xFF1A1D2D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Our team is available 24/7",
                  style: TextStyle(color: Color(0xFF71768E), fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D7132),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Contact Us",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
