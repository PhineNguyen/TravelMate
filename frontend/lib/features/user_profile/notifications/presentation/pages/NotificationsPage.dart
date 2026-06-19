import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["All", "Unread", "Budget", "Weather"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 15),
            _buildFilterTabs(),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNotificationCard(
                    icon: Icons.warning_amber_rounded,
                    title: "Weather alert — Japan Discovery",
                    description:
                        "Heavy rain (120mm) expected Apr 16–17 in Kyoto. AI has rescheduled 3 outdoor activities.",
                    time: "2 hours ago",
                    color: Colors.redAccent,
                    isUnread: true,
                  ),
                  _buildNotificationCard(
                    icon: Icons.account_balance_wallet_rounded,
                    title: "Budget warning — Japan Discovery",
                    description:
                        "Actual spending has reached 90% of your configured budget (\$4,200).",
                    time: "5 hours ago",
                    color: Colors.orangeAccent,
                    isUnread: true,
                  ),
                  _buildNotificationCard(
                    icon: Icons.person_add_rounded,
                    title: "Invitation accepted",
                    description:
                        "Sarah Kim joined Japan Discovery as a collaborator.",
                    time: "Yesterday, 14:22",
                    color: const Color(0xFF1ABC9C),
                    isUnread: true,
                  ),
                  _buildNotificationCard(
                    icon: Icons.smart_toy_rounded,
                    title: "AI itinerary ready",
                    description:
                        "Your 22-day Japan Discovery itinerary has been generated successfully.",
                    time: "2 days ago",
                    color: Colors.purpleAccent,
                    isUnread: false,
                  ),
                  _buildNotificationCard(
                    icon: Icons.check_circle_rounded,
                    title: "Route optimised",
                    description:
                        "Your Japan route was optimised. You'll save approximately 4h 20min of travel time.",
                    time: "3 days ago",
                    color: const Color(0xFF1ABC9C),
                    isUnread: false,
                  ),
                  const SizedBox(height: 30),
                  _buildMarkAsReadButton(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1ABC9C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFF1ABC9C).withOpacity(0.3)),
            ),
            child: const Text(
              "3 unread",
              style: TextStyle(
                color: Color(0xFF1ABC9C),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          bool isActive = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1ABC9C)
                      : const Color(0xFF172234),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          isActive ? Colors.transparent : Colors.grey.shade800),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF0B1423)
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnread ? color.withOpacity(0.3) : Colors.grey.shade800,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (isUnread)
                Container(
                  width: 5,
                  color: color,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (isUnread)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkAsReadButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1423),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done_all_rounded, color: Color(0xFF1ABC9C), size: 20),
            SizedBox(width: 10),
            Text(
              "Mark all as read",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
