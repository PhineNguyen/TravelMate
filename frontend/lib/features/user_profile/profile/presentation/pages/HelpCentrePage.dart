import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class HelpCentrePage extends StatelessWidget {
  const HelpCentrePage({super.key});

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
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search for help...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFF1ABC9C)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
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
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(topics[index]['icon'] as IconData,
                  color: const Color(0xFF1ABC9C), size: 28),
              const SizedBox(height: 12),
              Text(
                topics[index]['label'] as String,
                style: const TextStyle(
                    color: Colors.white,
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
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: faqs.map((faq) {
          return Column(
            children: [
              ListTile(
                title: Text(faq,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade700),
                onTap: () {},
              ),
              if (faq != faqs.last)
                Divider(color: Colors.grey.shade800, height: 1),
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1ABC9C).withValues(alpha: 0.1),
            const Color(0xFF172234),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: const Color(0xFF1ABC9C).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Still need help?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Our team is available 24/7",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1ABC9C),
              foregroundColor: const Color(0xFF0B1423),
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
