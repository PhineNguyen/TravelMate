import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class HistoryPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const HistoryPage({super.key, this.onBackToHome});

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
                title: "Trip history",
                onBack: onBackToHome,
                trailing: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  itemBuilder: (context) => [
                    _buildPopupItem(Icons.sort_rounded, "Sort by date"),
                    _buildPopupItem(
                        Icons.filter_list_rounded, "Filter by region"),
                    _buildPopupItem(Icons.download_rounded, "Export history"),
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
              ),
            ),
            const SizedBox(height: 15),
            _buildFilterRow(),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildHistoryCard(
                    title: "Japan Discovery 2025",
                    locations: "Tokyo · Kyoto · Osaka · Hiroshima",
                    date: "Apr 2025",
                    duration: "22 days",
                    cost: "\$4,180",
                    topColor: const Color(0xFF2D7132).withOpacity(0.05),
                    bannerIcon: Icons.explore_outlined,
                    iconColor: const Color(0xFF2D7132),
                  ),
                  const SizedBox(height: 20),
                  _buildHistoryCard(
                    title: "Paris & Côte d'Azur",
                    locations: "Paris · Nice · Monaco · Cannes",
                    date: "Aug 2024",
                    duration: "14 days",
                    cost: "\$3,600",
                    topColor: Colors.orange.shade50,
                    bannerIcon: Icons.fort_outlined,
                    iconColor: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 20),
                  _buildHistoryCard(
                    title: "Bali Sanctuary",
                    locations: "Ubud · Seminyak · Uluwatu",
                    date: "Nov 2024",
                    duration: "10 days",
                    cost: "\$2,100",
                    topColor: Colors.teal.shade50,
                    bannerIcon: Icons.beach_access_outlined,
                    iconColor: Colors.teal.shade700,
                  ),
                  const SizedBox(height: 20),
                  _buildHistoryCard(
                    title: "Morocco Cultural Tour",
                    locations: "Marrakech · Fez · Sahara · Chefchaouen",
                    date: "Mar 2024",
                    duration: "10 days",
                    cost: "\$1,900",
                    topColor: Colors.deepPurple.shade50,
                    bannerIcon: Icons.mosque_outlined,
                    iconColor: Colors.deepPurple.shade700,
                  ),
                  const SizedBox(height: 30),
                ],
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

  Widget _buildFilterRow() {
    final filters = ["All trips", "2025", "2024", "Asia", "Europe"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: filters.map((filter) {
          bool isActive = filter == "All trips";
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2D7132) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF71768E),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
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
            blurRadius: 15,
            offset: const Offset(0, 5),
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
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    bannerIcon,
                    size: 64,
                    color: iconColor.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D7132).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Completed",
                      style: TextStyle(
                        color: Color(0xFF2D7132),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
                    color: Color(0xFF1A1D2D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  locations,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF71768E),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildInfoItem(Icons.calendar_today, date),
                    const SizedBox(width: 15),
                    _buildInfoItem(Icons.access_time, duration),
                    const SizedBox(width: 15),
                    _buildInfoItem(Icons.account_balance_wallet, cost),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          size: 14,
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
        Icon(icon, size: 14, color: const Color(0xFFB0B3C1)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFB0B3C1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
