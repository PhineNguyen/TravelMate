import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/confirmation_dialog.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripPage.dart';

class AllTripsPage extends StatefulWidget {
  const AllTripsPage({super.key});

  @override
  State<AllTripsPage> createState() => _AllTripsState();
}

class _AllTripsState extends State<AllTripsPage> {
  // Bảng màu theo phong cách Preferences mới (Light & Fresh Green)
  static const Color kBackgroundColor = Color(0xFFF3F5F9);
  static const Color kPrimaryGreen = Color(0xFF6BB04D); // Xanh lục nút bấm
  static const Color kLightGreen = Color(0xFFEAF4E1); // Nền item được chọn
  static const Color kTextColor = Color(0xFF1A1D2D); // Chữ chính đậm
  static const Color kTextSubColor = Color(0xFF71768E); // Chữ phụ xám xanh
  static const Color kCardColor = Colors.white;

  bool _hasTrips = true; // Demo toggle

  void _showDeleteConfirmation(String tripName) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Delete Trip",
        message:
            "Are you sure you want to delete '$tripName'? This action cannot be undone.",
        confirmLabel: "Delete",
        isDestructive: true,
        onConfirm: () {
          // Logic xóa chuyến đi thực tế sẽ ở đây
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Trip '$tripName' deleted")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _hasTrips ? _buildTripList() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      title: "No trips found",
      description:
          "You haven't created any trips yet. Start planning your next adventure!",
      icon: Icons.map_outlined,
      actionLabel: "Plan a trip",
      onAction: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTripPage()),
      ),
    );
  }

  Widget _buildTripList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 10),
        _buildTripCard(
            "Japan Discovery",
            "Mar 12 - Mar 25, 2024",
            "12 places visited",
            "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=2070"),
        const SizedBox(height: 16),
        _buildTripCard(
            "Paris Getaway",
            "Jan 05 - Jan 12, 2024",
            "8 places visited",
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073"),
        const SizedBox(height: 16),
        _buildTripCard(
            "Bali Adventure",
            "Dec 20 - Dec 28, 2023",
            "15 places visited",
            "https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=2076"),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildCircleActionIcon(
                  Icons.arrow_back, () => Navigator.pop(context)),
              const SizedBox(width: 16),
              const Text(
                "All Trips",
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              _buildCircleActionIcon(Icons.ios_share, () {}),
              const SizedBox(width: 12),
              _buildPopupMenu(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        _buildPopupItem("edit", Icons.edit_outlined, "Edit List"),
        _buildPopupItem("sort", Icons.sort_rounded, "Sort by Date"),
        _buildPopupItem("clear", Icons.delete_sweep_outlined, "Clear All"),
      ],
      onSelected: (value) {
        if (value == "clear") {
          setState(() => _hasTrips = !_hasTrips); // Toggle for demo
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.more_horiz, color: kTextColor, size: 20),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
      String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: kTextColor, size: 18),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: kTextColor, fontSize: 14)),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: kTextColor, size: 20),
      ),
    );
  }

  Widget _buildTripCard(
      String title, String date, String stats, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(title,
                                style: const TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                          GestureDetector(
                            onTap: () => _showDeleteConfirmation(title),
                            child: const Icon(Icons.close,
                                size: 18, color: Colors.redAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 14, color: kTextSubColor),
                          const SizedBox(width: 6),
                          Text(date,
                              style: const TextStyle(
                                  color: kTextSubColor, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kLightGreen,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: kPrimaryGreen.withOpacity(0.1)),
                        ),
                        child: Text(stats,
                            style: const TextStyle(
                                color: kPrimaryGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFB0B3C1), size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
