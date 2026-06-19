import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_button.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRegenerateBar(),
                      const SizedBox(height: 25),
                      _buildDayHeader("DAY 1 — TOKYO ARRIVAL"),
                      _buildTimelineItem(
                        title: "Narita Airport → Shinjuku",
                        description:
                            "N'EX express, 90 min. Hotel check-in Park Hyatt Tokyo.",
                        time: "14:00 · 90 min",
                        dotColor: Colors.blueAccent,
                        chips: [
                          _buildTag("Transport", Colors.blueAccent),
                          _buildTag("¥3,250", Colors.blueAccent)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: "Shinjuku Gyoen stroll",
                        description:
                            "Cherry blossom viewing. Best light at golden hour.",
                        time: "16:30 · 2 hrs",
                        dotColor: const Color(0xFF1ABC9C),
                        chips: [
                          _buildTag("Outdoor", const Color(0xFF1ABC9C)),
                          _buildTag("Free", Colors.tealAccent)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: "Dinner — T's TanTan Ramen",
                        description:
                            "100% vegan ramen inside Shinjuku station. AI picked based on your vegetarian preference.",
                        time: "19:00 · 1hr",
                        dotColor: Colors.orangeAccent,
                        chips: [
                          _buildTag("Dining", Colors.orangeAccent),
                          _buildTag("AI pick", Colors.purpleAccent)
                        ],
                        isLast: true,
                      ),
                      const SizedBox(height: 10),
                      _buildDayHeader("DAY 2 — ASAKUSA & AKIHABARA"),
                      _buildTimelineItem(
                        title: "Senso-ji Temple",
                        description:
                            "Tokyo's oldest temple. Arrive before 8am to avoid crowds.",
                        time: "07:30 · 2 hrs",
                        dotColor: Colors.redAccent,
                        chips: [
                          _buildTag("Cultural", Colors.redAccent),
                          _buildTag("Historical", Colors.redAccent)
                        ],
                        isLast: false,
                      ),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF1ABC9C).withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        border: Border(
            bottom:
                BorderSide(color: const Color(0xFF1ABC9C).withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              const Text("AI-GENERATED · JAPAN DISCOVERY",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1ABC9C),
                      letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 25),
          const Text("22-day itinerary",
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildActionChip("Cultural", Colors.blueAccent),
              const SizedBox(width: 8),
              _buildActionChip("Culinary", const Color(0xFF1ABC9C)),
              const SizedBox(width: 8),
              _buildActionChip("\$4,200", Colors.purpleAccent),
              const Spacer(),
              _buildButtonShare(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRegenerateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.refresh, color: Colors.purpleAccent, size: 18),
          const SizedBox(width: 12),
          const Text("Regenerate with new preferences",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const Spacer(),
          Text("GPT-4o",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 4),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required Color dotColor,
    required List<Widget> chips,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF0B1423), width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade800,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF172234),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(description,
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            height: 1.5)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(time,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(children: chips),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildButtonShare() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: const Row(
          children: [
            Icon(Icons.ios_share, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text("Share",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1423).withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AppButton(
                label: "Save itinerary",
                icon: Icon(Icons.check_circle_outline),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: AppButton(
                label: "Map",
                icon: Icon(Icons.map_outlined),
                isPrimary: false,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
