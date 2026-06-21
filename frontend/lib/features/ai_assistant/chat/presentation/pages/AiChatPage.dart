import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class AiChatPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const AiChatPage({super.key, this.onBackToHome});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: AppHeader(
                title: "TravelMate AI",
                onBack: widget.onBackToHome,
                trailing: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: const Color(0xFF172234),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  itemBuilder: (context) => [
                    _buildPopupItem(Icons.delete_outline, "Clear conversation"),
                    _buildPopupItem(Icons.settings_outlined, "AI Settings"),
                    _buildPopupItem(Icons.history, "Chat history"),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172234),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: const Icon(Icons.more_horiz_rounded,
                        color: Colors.grey, size: 20),
                  ),
                ),
                bottom: [
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF1ABC9C),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text("Online • GPT-4o",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildAiMessage(
                    "Hello Alex! I'm your AI travel assistant. I can help you plan, adjust, and optimise your Japan trip in real time. What can I help with?",
                    "9:41 AM",
                  ),
                  _buildUserMessage(
                    "Find vegetarian ramen near Shinjuku station",
                    "9:42 AM",
                  ),
                  _buildAiRichMessage(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Top 3 vegetarian-friendly ramen spots within 5 min of Shinjuku:",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 15),
                        _buildSpotInfo(
                            "T's TanTan",
                            " — 100% vegan, inside the station. Sesame tantanmen is exceptional.",
                            const Color(0xFF1ABC9C)),
                        const SizedBox(height: 12),
                        _buildSpotInfo(
                            "Soranoiro NIPPON",
                            " — Colourful vegetable broth options, open until 23:00.",
                            Colors.blueAccent),
                        const SizedBox(height: 12),
                        _buildSpotInfo(
                            "Afuri Harajuku",
                            " — 20 min away, yuzu shio vegan ramen.",
                            Colors.purpleAccent),
                      ],
                    ),
                    "9:42 AM",
                  ),
                  _buildUserMessage(
                      "Add T's TanTan to Day 1 dinner", "9:43 AM"),
                  _buildAiMessage(
                    "Done! T's TanTan added at 19:00 on Day 1. Future dining suggestions will be filtered for vegetarian options automatically.",
                    "9:43 AM",
                  ),
                ],
              ),
            ),
            _buildQuickActions(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(IconData icon, String label) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAiMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: const Color(0xFF172234),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                ),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.white, height: 1.5)),
            ),
            const SizedBox(height: 8),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAiRichMessage(Widget content, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: const Color(0xFF172234),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                ),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: content,
            ),
            const SizedBox(height: 8),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotInfo(String name, String description, Color nameColor) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, height: 1.4),
        children: [
          TextSpan(
              text: "• $name",
              style: TextStyle(color: nameColor, fontWeight: FontWeight.bold)),
          TextSpan(
              text: description, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: const Color(0xFF1ABC9C),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF1ABC9C).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0B1423),
                      height: 1.5,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildActionChip("Weather tomorrow?"),
          _buildActionChip("Reoptimise Day 3"),
          _buildActionChip("Translate menu"),
          _buildActionChip("Nearby ATMs"),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF172234),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade800),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
                color: Color(0xFF1ABC9C),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        border: Border(top: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0B1423),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.grey, size: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1423),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ask anything about your trip...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1ABC9C),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded,
                  color: Color(0xFF0B1423), size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
