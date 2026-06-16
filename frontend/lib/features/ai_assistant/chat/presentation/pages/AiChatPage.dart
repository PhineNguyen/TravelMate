import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(), // Đồng bộ gradient nền
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                color: Color(0xFF101828),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 15),
                          _buildSpotInfo(
                              "T's TanTan",
                              " — 100% vegan, inside the station. Sesame tantanmen is exceptional.",
                              const Color(0xFF12927F)),
                          const SizedBox(height: 12),
                          _buildSpotInfo(
                              "Soranoiro NIPPON",
                              " — Colourful vegetable broth options, open until 23:00.",
                              const Color(0xFF2D68FF)),
                          const SizedBox(height: 12),
                          _buildSpotInfo(
                              "Afuri Harajuku",
                              " — 20 min away, yuzu shio vegan ramen.",
                              const Color(0xFF8B5CF6)),
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
      ),
    );
  }

  // 1. Background đồng bộ
  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

  // 2. Header đồng bộ
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF101828), size: 22),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Color(0xFF8B5CF6), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TravelMate AI",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101828)),
              ),
              Row(
                children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: Color(0xFF12927F), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text("Online • GPT-4o",
                      style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz_rounded,
                  color: Color(0xFF98A2B3))),
        ],
      ),
    );
  }

  // 3. AI Message Bubble (Trắng, Shadow mượt)
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
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF101828), height: 1.5)),
            ),
            const SizedBox(height: 6),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
          ],
        ),
      ),
    );
  }

  // 4. AI Rich Message (Dùng cho danh sách điểm đến)
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
              constraints: const BoxConstraints(maxWidth: 290),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: content,
            ),
            const SizedBox(height: 6),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
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
              text: description,
              style: const TextStyle(color: Color(0xFF475467))),
        ],
      ),
    );
  }

  // 5. User Message Bubble (Xanh Blue, bo góc đối xứng)
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
                gradient: const LinearGradient(
                    colors: [Color(0xFF2D68FF), Color(0xFF0047FF)]),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF2D68FF).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 6),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
          ],
        ),
      ),
    );
  }

  // 6. Quick Action Chips (Màu tím đồng bộ Template)
  Widget _buildQuickActions() {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 7. Input Area (Bo tròn, Glassmorphism style)
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(top: BorderSide(color: Color(0xFFEAECF0))),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Color(0xFF98A2B3))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5FF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Ask anything about your trip...",
                  hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
