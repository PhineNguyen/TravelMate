import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const ChatPage({super.key, this.onBackToHome});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose(); // Quan trọng: Giải phóng bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            _buildHeader(context),

            // --- DANH SÁCH TIN NHẮN ---
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                children: const [
                  _MemberMessage(
                    name: "Alex Johnson",
                    time: "9:40 AM",
                    text:
                        "Hey team — quick heads up. I updated Day 3 with an evening activity.",
                    initials: "AJ",
                    avatarColor: Color(0xFF1ABC9C),
                  ),
                  _MemberMessage(
                    name: "Sarah Kim",
                    time: "9:41 AM",
                    text: "Looks good — can we shift lunch earlier?",
                    initials: "SK",
                    avatarColor: Colors.deepPurpleAccent,
                  ),
                ],
              ),
            ),

            // --- INPUT AREA ---
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
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
      child: Column(
        children: [
          Row(
            children: [
              _buildCircleActionIcon(
                Icons.arrow_back,
                widget.onBackToHome ?? () => Navigator.pop(context),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Group Chat - Japan Discovery",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Collaborators • 2 members",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildPopupMenu(),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade800, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      color: const Color(0xFF172234),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) {},
      itemBuilder: (context) => [
        _buildPopupItem(Icons.supervisor_account_outlined, "See chat member"),
        _buildPopupItem(Icons.settings_outlined, "Setting"),
        _buildPopupItem(Icons.delete_outline, "Delete conversation",
            isDestructive: true),
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label,
      {bool isDestructive = false}) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon,
              color: isDestructive ? Colors.redAccent : Colors.white, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: isDestructive ? Colors.redAccent : Colors.white,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF172234),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1423),
        border: Border(top: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF1ABC9C),
            child: Text("AJ",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1423))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF172234),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Message collaborators...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nút gửi (Sử dụng IconButton để có hiệu ứng feedback tốt hơn)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Color(0xFF1ABC9C), shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.send_rounded,
                  color: Color(0xFF0B1423), size: 18),
              onPressed: () {
                // Xử lý gửi tin nhắn
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Tách Widget tin nhắn để tối ưu hóa render
class _MemberMessage extends StatelessWidget {
  final String name;
  final String time;
  final String text;
  final String initials;
  final Color avatarColor;

  const _MemberMessage({
    required this.name,
    required this.time,
    required this.text,
    required this.initials,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: const TextStyle(
                  color: Color(0xFF0B1423),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172234),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                        color: Colors.grey.shade800.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14, height: 1.4),
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
