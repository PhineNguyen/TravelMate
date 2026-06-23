import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/confirmation_dialog.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';

class ItineraryPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const ItineraryPage({super.key, this.onBackToHome});

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Reset Schedule",
        message:
            "This will remove all current activities and reset Day 1. You cannot undo this action.",
        confirmLabel: "Reset",
        isDestructive: true,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Schedule has been reset")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                  child: AppHeader(
                    title: "22-day itinerary",
                    onBack: onBackToHome,
                    trailing: PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onSelected: (value) {
                        if (value == "reset") {
                          _showResetConfirmation(context);
                        }
                      },
                      itemBuilder: (context) => [
                        _buildPopupItem(Icons.edit_outlined, "Edit itinerary"),
                        _buildPopupItem(Icons.ios_share, "Share itinerary"),
                        _buildPopupItem(
                            Icons.picture_as_pdf_outlined, "Export to PDF"),
                        _buildPopupItem(Icons.delete_outline, "Reset schedule",
                            isDestructive: true, value: "reset"),
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
                        child: const Icon(Icons.more_horiz_rounded,
                            color: Color(0xFF1A1D2D), size: 20),
                      ),
                    ),
                    bottom: [
                      Row(
                        children: [
                          _buildActionChip("Cultural", Colors.blue.shade700),
                          const SizedBox(width: 8),
                          _buildActionChip("Culinary", const Color(0xFF2D7132)),
                          const SizedBox(width: 8),
                          _buildActionChip("\$4,200", Colors.purple.shade700),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRegenerateBar(),
                      const SizedBox(height: 25),
                      _buildDayHeader("DAY 1 — TOKYO ARRIVAL"),
                      _buildTimelineItem(
                        context: context,
                        title: "Narita Airport → Shinjuku",
                        description:
                            "N'EX express, 90 min. Hotel check-in Park Hyatt Tokyo.",
                        time: "14:00 · 90 min",
                        dotColor: Colors.blue.shade700,
                        chips: [
                          _buildTag("Transport", Colors.blue.shade700),
                          _buildTag("¥3,250", Colors.blue.shade700)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        context: context,
                        title: "Shinjuku Gyoen stroll",
                        description:
                            "Cherry blossom viewing. Best light at golden hour.",
                        time: "16:30 · 2 hrs",
                        dotColor: const Color(0xFF2D7132),
                        chips: [
                          _buildTag("Outdoor", const Color(0xFF2D7132)),
                          _buildTag("Free", Colors.teal.shade700)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        context: context,
                        title: "Dinner — T's TanTan Ramen",
                        description:
                            "100% vegan ramen inside Shinjuku station. AI picked based on your vegetarian preference.",
                        time: "19:00 · 1hr",
                        dotColor: Colors.orange.shade700,
                        chips: [
                          _buildTag("Dining", Colors.orange.shade700),
                          _buildTag("AI pick", Colors.purple.shade700)
                        ],
                        isLast: true,
                      ),
                      const SizedBox(height: 10),
                      _buildDayHeader("DAY 2 — ASAKUSA & AKIHABARA"),
                      _buildTimelineItem(
                        context: context,
                        title: "Senso-ji Temple",
                        description:
                            "Tokyo's oldest temple. Arrive before 8am to avoid crowds.",
                        time: "07:30 · 2 hrs",
                        dotColor: Colors.red.shade700,
                        chips: [
                          _buildTag("Cultural", Colors.red.shade700),
                          _buildTag("Historical", Colors.red.shade700)
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

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label,
      {bool isDestructive = false, String? value}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon,
              color:
                  isDestructive ? Colors.red.shade600 : const Color(0xFF1A1D2D),
              size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: isDestructive
                      ? Colors.red.shade600
                      : const Color(0xFF1A1D2D),
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildRegenerateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, color: Colors.purple.shade700, size: 18),
          const SizedBox(width: 12),
          Text("Regenerate with new preferences",
              style: TextStyle(
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const Spacer(),
          const Text("GPT-4o",
              style: TextStyle(
                  color: Color(0xFFB0B3C1),
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
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF71768E),
            letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
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
                        Border.all(color: const Color(0xFFF1F4FA), width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFE2E4EB),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () {
                  // Link context: Show info or jump to map
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Showing details for $title")),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFF1A1D2D))),
                      const SizedBox(height: 8),
                      Text(description,
                          style: const TextStyle(
                              color: Color(0xFF71768E),
                              fontSize: 14,
                              height: 1.5)),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Color(0xFFB0B3C1)),
                          const SizedBox(width: 6),
                          Text(time,
                              style: const TextStyle(
                                  color: Color(0xFFB0B3C1),
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
          borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
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
          color: Colors.white.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AppButton(
                label: "Save itinerary",
                icon:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: AppButton(
                label: "Map",
                icon: const Icon(Icons.map_outlined, color: Color(0xFF1A1D2D)),
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
