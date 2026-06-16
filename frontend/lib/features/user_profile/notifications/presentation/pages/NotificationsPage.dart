import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["All", "Unread", "Budget", "Weather"];

  // Color Palette
  static const Color darkGreen = Color(0xFF0F4D1E);
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color mintGreen = Color(0xFFB6D7A8);
  static const Color paleGreen = Color(0xFFE8F3DC);
  static const Color white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildFilterTabs(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildNotificationCard(
                      icon: Icons.warning_amber_rounded,
                      title: "Weather alert — Japan Discovery",
                      description:
                          "Heavy rain (120mm) expected Apr 16–17 in Kyoto. AI has rescheduled 3 outdoor activities.",
                      time: "2 hours ago",
                      color: forestGreen,
                      isUnread: true,
                    ),
                    _buildNotificationCard(
                      icon: Icons.account_balance_wallet_rounded,
                      title: "Budget warning — Japan Discovery",
                      description:
                          "Actual spending has reached 90% of your configured budget (\$4,200).",
                      time: "5 hours ago",
                      color: forestGreen,
                      isUnread: true,
                    ),
                    _buildNotificationCard(
                      icon: Icons.person_add_rounded,
                      title: "Invitation accepted",
                      description:
                          "Sarah Kim joined Japan Discovery as a collaborator.",
                      time: "Yesterday, 14:22",
                      color: forestGreen,
                      isUnread: true,
                    ),
                    _buildNotificationCard(
                      icon: Icons.smart_toy_rounded,
                      title: "AI itinerary ready",
                      description:
                          "Your 22-day Japan Discovery itinerary has been generated successfully.",
                      time: "2 days ago",
                      color: mintGreen,
                      isUnread: false,
                    ),
                    _buildNotificationCard(
                      icon: Icons.check_circle_rounded,
                      title: "Route optimised",
                      description:
                          "Your Japan route was optimised. You'll save approximately 4h 20min of travel time.",
                      time: "3 days ago",
                      color: mintGreen,
                      isUnread: false,
                    ),
                    const SizedBox(height: 20),
                    _buildMarkAsReadButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Background Gradient (Pale Green -> White)
  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [paleGreen, white],
      ),
    );
  }

  // 2. Header (Dark Green Text, Forest Green Badge)
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: darkGreen, size: 22),
          ),
          const SizedBox(width: 5),
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkGreen,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: forestGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "3 unread",
              style: TextStyle(
                color: forestGreen,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Filter Tabs (Forest Green Active, White Inactive)
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildTab(
              label: _tabs[index],
              isActive: _selectedIndex == index,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? forestGreen : white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (!isActive)
              BoxShadow(
                color: darkGreen.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? white : Color(0xFF667085),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // 4. Notification Card (White BG, Dark Green Text)
  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: isUnread
            ? Border.all(color: color.withOpacity(0.2), width: 1)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
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
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                                if (isUnread)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: forestGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475467),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 14,
                                    color: forestGreen.withOpacity(0.5)),
                                const SizedBox(width: 4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF667085),
                                    fontWeight: FontWeight.w500,
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

  // 5. Button (White BG, Forest Green Text, Mint Green Border)
  Widget _buildMarkAsReadButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: mintGreen),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withOpacity(0.02),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.done_all_rounded, color: forestGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              "Mark all as read",
              style: TextStyle(
                color: forestGreen,
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
