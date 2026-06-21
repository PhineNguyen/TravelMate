import 'package:flutter/material.dart';

class AllTripsPage extends StatefulWidget {
  const AllTripsPage({super.key});

  @override
  State<AllTripsPage> createState() => _AllTripsState();
}

class _AllTripsState extends State<AllTripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildTripCard("Japan Discovery", "Mar 12 - Mar 25, 2024",
                      "12 places visited", "assets/japan.jpg"),
                  const SizedBox(height: 16),
                  _buildTripCard("Paris Getaway", "Jan 05 - Jan 12, 2024",
                      "8 places visited", "assets/paris.jpg"),
                  const SizedBox(height: 16),
                  _buildTripCard("Bali Adventure", "Dec 20 - Dec 28, 2023",
                      "15 places visited", "assets/bali.jpg"),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1ABC9C).withValues(alpha: 0.15),
            const Color(0xFF0B1423),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleActionIcon(
                  Icons.arrow_back, () => Navigator.pop(context)),
              const Text(
                "All Trips",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildCircleActionIcon(Icons.ios_share, () {}),
                  const SizedBox(width: 12),
                  PopupMenuButton<String>(
                    onSelected: (value) {},
                    offset: const Offset(0, 50),
                    color: const Color(0xFF172234),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit List",
                              style: TextStyle(color: Colors.white))),
                      const PopupMenuItem(
                          value: "sort",
                          child: Text("Sort by Date",
                              style: TextStyle(color: Colors.white))),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF172234),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: const Icon(Icons.more_horiz,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildTripCard(
      String title, String date, String stats, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(date,
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                const SizedBox(height: 8),
                Text(stats,
                    style: const TextStyle(
                        color: Color(0xFF1ABC9C),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade700),
        ],
      ),
    );
  }
}
