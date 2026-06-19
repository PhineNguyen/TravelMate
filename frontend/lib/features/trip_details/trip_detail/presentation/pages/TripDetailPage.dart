import 'package:flutter/material.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 30),
                  _buildTripInfoCard(),
                  const SizedBox(height: 20),
                  _buildCollaboratorsCard(),
                  const SizedBox(height: 20),
                  _buildBudgetOverviewCard(),
                  const SizedBox(height: 20),
                  _buildWeatherAlertCard(),
                  const SizedBox(height: 40),
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
            const Color(0xFF1ABC9C).withOpacity(0.15),
            const Color(0xFF0B1423),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleActionIcon(
                  Icons.arrow_back, () => Navigator.pop(context)),
              Row(
                children: [
                  _buildCircleActionIcon(Icons.ios_share, () {}),
                  const SizedBox(width: 12),
                  _buildCircleActionIcon(Icons.more_horiz, () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildBadge(
                  "Active", const Color(0xFF1ABC9C), const Color(0xFF0B1423)),
              const SizedBox(width: 10),
              _buildBadge(
                  "Day 8 of 22", const Color(0xFF172234), Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "JAPAN DISCOVERY 2025",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tokyo · Kyoto · Osaka",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
            Icons.list_alt_rounded, "Itinerary", const Color(0xFF1ABC9C)),
        _buildActionItem(
            Icons.account_balance_wallet_outlined, "Budget", Colors.tealAccent),
        _buildActionItem(Icons.map_outlined, "Map", Colors.deepPurpleAccent),
        _buildActionItem(
            Icons.chat_bubble_outline_rounded, "Chat", Colors.orangeAccent),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("TRIP INFO"),
              _buildBadge("PLANNED", const Color(0xFF1ABC9C).withOpacity(0.15),
                  const Color(0xFF1ABC9C)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _buildInfoColumn(
                  Icons.calendar_today_rounded, "Dates", "Apr 12 – May 3"),
              _buildInfoColumn(Icons.timer_outlined, "Duration", "22 days"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoColumn(
                  Icons.people_outline_rounded, "Travellers", "2 persons"),
              _buildInfoColumn(
                  Icons.account_balance_wallet_outlined, "Budget", "\$4,200"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String title, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14)),
          ]),
        ],
      ),
    );
  }

  Widget _buildCollaboratorsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("COLLABORATORS"),
              _buildTextButton("Invite"),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildAvatar("AJ", const Color(0xFF1ABC9C)),
              const SizedBox(width: 10),
              _buildAvatar("SK", Colors.deepPurpleAccent),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1423),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: const Icon(Icons.add, color: Colors.grey, size: 20),
                ),
              ),
              const SizedBox(width: 15),
              Text("2 members",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String text, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Color(0xFF0B1423),
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBudgetOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionLabel("BUDGET OVERVIEW"),
              _buildTextButton("Add expense"),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Spent \$1,842",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text("44% of \$4,200",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.44,
              minHeight: 10,
              backgroundColor: Color(0xFF0B1423),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1ABC9C)),
            ),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF0B1423),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: const Center(
                child: Text(
                  "Full budget tracker",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextButton(String title) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1ABC9C),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildWeatherAlertCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.redAccent, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Heavy rain — Apr 16–17",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 13, height: 1.4),
                    children: [
                      const TextSpan(
                          text: "AI rescheduled 3 outdoor activities. "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "See forecast →",
                            style: TextStyle(
                                color: Color(0xFF1ABC9C),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
