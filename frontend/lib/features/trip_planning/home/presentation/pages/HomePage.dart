import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/confirmation_dialog.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/ai_assistant/chat/presentation/pages/AiChatPage.dart';
import 'package:frontend/features/trip_details/weather/presentation/pages/WeatherPage.dart';
import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripPage.dart';
import 'package:frontend/features/trip_planning/home/presentation/pages/AllTripPage.dart';
import 'package:frontend/features/trip_planning/templates/presentation/pages/TemplatesPage.dart';
import 'package:frontend/features/user_profile/notifications/presentation/pages/NotificationsPage.dart';
import 'package:frontend/features/user_profile/profile/presentation/pages/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasTrips = true; // Demo toggle

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
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildSearchBar(context),
              const SizedBox(height: 30),
              _buildSummaryGrid(),
              const SizedBox(height: 25),
              _buildSectionHeader("QUICK ACTIONS"),
              const SizedBox(height: 15),
              _buildQuickActions(context),
              const SizedBox(height: 25),
              _buildSectionHeader(
                "CURRENT TRIPS",
                actionText: hasTrips ? "See all" : null,
                context: context,
                page: const AllTripsPage(),
              ),
              const SizedBox(height: 15),
              if (hasTrips) ...[
                _buildTripCard(
                  "Japan Discovery",
                  "Tokyo · Kyoto · Osaka",
                  "Apr 12 – May 3  ·  2 pax  ·  \$4,200",
                  0.36,
                  "Active",
                  const Color(0xFF2D7132),
                ),
                const SizedBox(height: 15),
                _buildTripCard(
                  "Amalfi Weekend",
                  "Positano · Ravello · Capri",
                  "Jun 18 – 22  ·  4 pax  ·  \$2,800",
                  0.0,
                  "Upcoming",
                  Colors.orange.shade700,
                ),
              ] else
                EmptyState(
                  title: "No trips planned yet",
                  description:
                      "Start your journey by creating a new trip or explore our templates.",
                  icon: Icons.luggage_outlined,
                  actionLabel: "Create a trip",
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateTripPage()),
                  ),
                ),
              const SizedBox(height: 20),
              _buildSectionHeader(
                "WEATHER ALERT",
                actionText: "Details",
                context: context,
                page: const WeatherPage(),
              ),
              const SizedBox(height: 10),
              _buildWeatherAlert(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning, traveller",
                style: TextStyle(color: Color(0xFF71768E), fontSize: 14)),
            Text("Alex Johnson",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D))),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        onBackToHome: () => Navigator.pop(context),
                      )),
            );
          },
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF2D7132),
                child: Text(
                  "AJ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ABC9C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search destinations...",
                hintStyle:
                    const TextStyle(color: Color(0xFFB0B3C1), fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB0B3C1)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onSubmitted: (value) {
                // Future: Show search results
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsPage()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1A1D2D),
                    size: 26,
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text("3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard("ACTIVE TRIPS", "3", "↑ 1 this month",
                const Color(0xFF2D7132), const Color(0xFFE8F5E9)),
            const SizedBox(width: 15),
            _buildStatCard("COUNTRIES", "24", "↑ 2 this year",
                const Color(0xFF7CB342), const Color(0xFFF1F8E9)),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildStatCard("AI SAVINGS", "\$1.2k", "vs manual booking",
                const Color(0xFF00ACC1), const Color(0xFFE0F7FA)),
            const SizedBox(width: 15),
            _buildStatCard("AI PICKS", "47", "81% accepted",
                const Color(0xFFD84315), const Color(0xFFFBE9E7)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String sub, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1.1)),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D))),
            const SizedBox(height: 4),
            Text(sub,
                style: const TextStyle(fontSize: 11, color: Color(0xFF71768E))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.add, "New trip", const Color(0xFF2D7132), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTripPage()));
        }),
        _buildActionItem(
            Icons.grid_view_rounded, "Templates", const Color(0xFF009688), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TemplatesPage()));
        }),
        _buildActionItem(
            Icons.smart_toy_outlined, "AI chat", const Color(0xFF8BC34A), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AiChatPage()));
        }),
        _buildActionItem(
            Icons.cloud_queue_rounded, "Weather", const Color(0xFFD32F2F), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WeatherPage()));
        }),
      ],
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, VoidCallback ontap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 75,
            height: 75,
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
            child: InkWell(
              onTap: ontap,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF71768E)),
        ),
      ],
    );
  }

  Widget _buildTripCard(String title, String locations, String info,
      double progress, String status, Color themeColor) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(height: 4, color: themeColor),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1D2D))),
                      _buildStatusBadge(status, themeColor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(locations,
                      style: const TextStyle(
                          color: Color(0xFF71768E), fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Color(0xFFB0B3C1)),
                      const SizedBox(width: 6),
                      Text(info,
                          style: const TextStyle(
                              color: Color(0xFFB0B3C1), fontSize: 11)),
                    ],
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFE2E4EB),
                          color: themeColor,
                          minHeight: 6),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Day 8 of 22",
                            style: TextStyle(
                                fontSize: 11,
                                color: themeColor,
                                fontWeight: FontWeight.bold)),
                        const Text("36%",
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF71768E))),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeatherAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFD32F2F), size: 22),
              const SizedBox(width: 12),
              const Expanded(
                  child: Text("Heavy rain — Kyoto Apr 16–17",
                      style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.bold,
                          fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
              "120mm expected. AI has rescheduled 3 outdoor activities automatically.",
              style: TextStyle(
                  color: Color(0xFF71768E), fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {String? actionText, BuildContext? context, Widget? page}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.2)),
        if (actionText != null)
          GestureDetector(
            onTap: (page != null && context != null)
                ? () => Navigator.push(
                      context!,
                      MaterialPageRoute(
                        builder: (context) => page,
                      ),
                    )
                : null,
            child: Text(
              actionText,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132)),
            ),
          ),
      ],
    );
  }
}
