import 'package:flutter/material.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["All", "Unread", "Budget", "Weather"];
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await ApiClient.fetchNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _notifications = const [];
        _isLoading = false;
      });
    }
  }

  List<NotificationModel> get _filteredNotifications {
    switch (_selectedIndex) {
      case 1:
        return _notifications.where((n) => !(n.isRead)).toList();
      case 2:
        return _notifications
            .where((n) =>
                n.type.toUpperCase() == 'BUDGET' ||
                n.title.toLowerCase().contains('budget'))
            .toList();
      case 3:
        return _notifications
            .where((n) =>
                n.type.toUpperCase() == 'WEATHER' ||
                n.title.toLowerCase().contains('weather'))
            .toList();
      default:
        return _notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleNotifications = _filteredNotifications;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, unreadCount),
            const SizedBox(height: 15),
            _buildFilterTabs(),
            const SizedBox(height: 15),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (visibleNotifications.isEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'No notifications match this filter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF71768E),
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          for (final notification in visibleNotifications) ...[
                            _buildNotificationCard(
                              icon: _iconForType(notification.type),
                              title: notification.title,
                              description: notification.description,
                              time: _formatTime(notification.createdAt),
                              color: _colorForType(notification.type),
                              isUnread: !notification.isRead,
                            ),
                          ],
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

  Widget _buildHeader(BuildContext context, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF1A1D2D), size: 24),
          ),
          const SizedBox(width: 8),
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D2D),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2D7132).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$unreadCount unread",
              style: const TextStyle(
                color: Color(0xFF2D7132),
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
                  _tabs[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF71768E),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                                      color: Color(0xFF1A1D2D),
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
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF71768E),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 14, color: Color(0xFFB0B3C1)),
                                const SizedBox(width: 6),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFB0B3C1),
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
      onTap: () async {
        try {
          await ApiClient.markAllNotificationsRead();
          await _loadNotifications();
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot update notifications: $error')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done_all_rounded, color: Color(0xFF2D7132), size: 20),
            SizedBox(width: 10),
            Text(
              "Mark all as read",
              style: TextStyle(
                color: Color(0xFF1A1D2D),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'BUDGET':
        return Icons.account_balance_wallet_rounded;
      case 'WEATHER':
        return Icons.warning_amber_rounded;
      case 'INVITE':
      case 'GROUP_INVITE':
        return Icons.person_add_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type.toUpperCase()) {
      case 'BUDGET':
        return Colors.orange.shade700;
      case 'WEATHER':
        return const Color(0xFFD32F2F);
      case 'INVITE':
      case 'GROUP_INVITE':
        return const Color(0xFF2D7132);
      default:
        return Colors.purple.shade700;
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Recently';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
