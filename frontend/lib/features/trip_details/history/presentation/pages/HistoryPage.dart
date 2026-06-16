import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
          "Trip history",
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilterRow(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHistoryCard(
                  title: "Japan Discovery 2025",
                  locations: "Tokyo · Kyoto · Osaka · Hiroshima",
                  date: "Apr 2025",
                  duration: "22 days",
                  cost: "\$4,180",
                  topColor: const Color(0xFFEEF2FF),
                  bannerIcon: Icons.explore_outlined,
                  iconColor: const Color(0xFF2D68FF),
                ),
                const SizedBox(height: 20),
                _buildHistoryCard(
                  title: "Paris & Côte d'Azur",
                  locations: "Paris · Nice · Monaco · Cannes",
                  date: "Aug 2024",
                  duration: "14 days",
                  cost: "\$3,600",
                  topColor: const Color(0xFFFFFBEB),
                  bannerIcon: Icons.fort_outlined,
                  iconColor: const Color(0xFFD97706),
                ),
                const SizedBox(height: 20),
                _buildHistoryCard(
                  title: "Bali Sanctuary",
                  locations: "Ubud · Seminyak · Uluwatu",
                  date: "Nov 2024",
                  duration: "10 days",
                  cost: "\$2,100",
                  topColor: const Color(0xFFE6F9F1),
                  bannerIcon: Icons.beach_access_outlined,
                  iconColor: const Color(0xFF12927F),
                ),
                const SizedBox(height: 20),
                _buildHistoryCard(
                  title: "Morocco Cultural Tour",
                  locations: "Marrakech · Fez · Sahara · Chefchaouen",
                  date: "Mar 2024",
                  duration: "10 days",
                  cost: "\$1,900",
                  topColor: const Color(0xFFF9F5FF),
                  bannerIcon: Icons.mosque_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ["All trips", "2025", "2024", "Asia", "Europe"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: filters.map((filter) {
          bool isActive = filter == "All trips";
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF98A2B3),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              selected: isActive,
              selectedColor: const Color(0xFF2D68FF),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color:
                      isActive ? Colors.transparent : const Color(0xFFEAECF0),
                ),
              ),
              onSelected: (bool selected) {},
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String locations,
    required String date,
    required String duration,
    required String cost,
    required Color topColor,
    required IconData bannerIcon,
    required Color iconColor,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: topColor,
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    bannerIcon,
                    size: 60,
                    color: iconColor.withOpacity(0.1),
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      color: Color(0xFF12927F),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locations,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF667085),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(Icons.calendar_today_outlined, date),
                    const SizedBox(width: 12),
                    _buildInfoItem(Icons.access_time, duration),
                    const SizedBox(width: 12),
                    _buildInfoItem(Icons.account_balance_wallet_outlined, cost),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_outline,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
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

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF98A2B3)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF98A2B3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
