import 'package:flutter/material.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRegenerateBar(),
                      const SizedBox(height: 10),
                      _buildDayHeader("DAY 1 — TOKYO ARRIVAL"),
                      _buildTimelineItem(
                        title: "Narita Airport → Shinjuku",
                        description:
                            "N'EX express, 90 min. Hotel check-in Park Hyatt Tokyo.",
                        time: "14:00 · 90 min",
                        dotColor: Colors.blue,
                        chips: [
                          _buildTag("Transport", Colors.blue),
                          _buildTag("¥3,250", Colors.blue)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: "Shinjuku Gyoen stroll",
                        description:
                            "Cherry blossom viewing. Best light at golden hour.",
                        time: "16:30 · 2 hrs",
                        dotColor: Colors.teal,
                        chips: [
                          _buildTag("Outdoor", Colors.teal),
                          _buildTag("Free", Colors.green)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: "Dinner — T's TanTan Ramen",
                        description:
                            "100% vegan ramen inside Shinjuku station. AI picked based on your vegetarian preference.",
                        time: "19:00 · 1hr",
                        dotColor: Colors.red,
                        chips: [
                          _buildTag("Dining", Colors.red),
                          _buildTag("AI pick", Colors.purple)
                        ],
                        isLast: true,
                      ),
                      _buildDayHeader("DAY 2 — ASAKUSA & AKIHABARA"),
                      _buildTimelineItem(
                        title: "Senso-ji Temple",
                        description:
                            "Tokyo's oldest temple. Arrive before 8am to avoid crowds.",
                        time: "07:30 · 2 hrs",
                        dotColor: Colors.orange,
                        chips: [
                          _buildTag("Cultural", Colors.orange),
                          _buildTag("Historical", Colors.orange)
                        ],
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: "Senso-ji Temple",
                        description:
                            "Tokyo's oldest temple. Arrive before 8am to avoid crowds.",
                        time: "07:30 · 2 hrs",
                        dotColor: Colors.green,
                        chips: [
                          _buildTag("Cultural", Colors.orange),
                          _buildTag("Historical", Colors.orange)
                        ],
                        isLast: false,
                      ),
                      _buildDayHeader("DAY 3 — ASAKUSA & AKIHABARA"),
                      _buildTimelineItem(
                        title: "Senso-ji Temple",
                        description:
                            "Tokyo's oldest temple. Arrive before 8am to avoid crowds.",
                        time: "07:30 · 2 hrs",
                        dotColor: Colors.orange,
                        chips: [
                          _buildTag("Cultural", Colors.orange),
                          _buildTag("Historical", Colors.orange)
                        ],
                        isLast: false,
                      ),
                      const SizedBox(height: 10), // Khoảng trống cho bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Action Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  // --- 1. HEADER ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2FE),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 10),
              const Text("AI-GENERATED · JAPAN DISCOVERY",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("22-day itinerary",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101828))),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildActionChip("Cultural", Colors.blue),
              const SizedBox(width: 5),
              _buildActionChip("Culinary", Colors.green),
              const SizedBox(width: 5),
              _buildActionChip("\$4,200", Colors.purple),
              const Spacer(),
              _buildButtonShare(),
            ],
          )
        ],
      ),
    );
  }

  // --- 2. REGENERATE BAR ---
  Widget _buildRegenerateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.refresh, color: Colors.purple, size: 20),
          const SizedBox(width: 10),
          const Text("Regenerate with new preferences",
              style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const Spacer(),
          Text("GPT-4o",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      ),
    );
  }

  // --- 3. TIMELINE ITEM ---
  Widget _buildDayHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 1),
      ),
    );
  }

// Widget _buildButton{
//     return ElevatedButton(onPressed: (){}, child: Row(const Icons(Icon(Icons.)),),),
// }
  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required Color dotColor,
    required List<Widget> chips,
    required bool isLast,
  }) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Ép các con cao bằng nhau
            children: [
              // --- CỘT CHỨA ĐƯỜNG KẺ LIỀN MẠCH ---
              SizedBox(
                width: 15, // Độ rộng cố định cho vùng timeline
                child: Column(
                  children: [
                    // Dấu chấm (Dot)
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(
                          top: 0), // Căn chỉnh dot khớp với dòng đầu của text
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    // Đường kẻ nối
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // --- CỘT CHỨA NỘI DUNG CARD ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20), // Tạo khoảng trống giữa các item ở đây
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(description,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                height: 1.4)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(time,
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(children: chips),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // Helper Widgets
  Widget _buildTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildButtonShare() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          //tap to share
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 46,
          width: 80,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share_outlined, size: 18, color: Colors.black87),
              Text("Share",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: icon == null ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: icon != null ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 14, color: Colors.grey),
          if (icon != null) const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: icon == null ? color : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- 4. BOTTOM BAR ---
  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Nút Save Itinerary
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  //logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D68FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, size: 20),
                    SizedBox(width: 8),
                    Text("Save itinerary",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nút View Map
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    //tap to open google map
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 56,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined,
                            size: 20, color: Colors.black87),
                        Text("View map",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
