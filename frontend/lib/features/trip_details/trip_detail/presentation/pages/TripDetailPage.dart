import 'package:flutter/material.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildQuickActions(),
                  const SizedBox(height: 15),
                  _buildTripInfoCard(),
                  const SizedBox(height: 15),
                  _buildCollaboratorsCard(),
                  const SizedBox(height: 15),
                  _buildBudgetOverviewCard(),
                  const SizedBox(height: 15),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD6E0FF),
            Color(0xFFF2F5FF),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleActionIcon(Icons.arrow_back_ios_new_rounded,
                  () => Navigator.pop(context)),
              Row(
                children: [
                  _buildCircleActionIcon(Icons.reply, () {}),
                  const SizedBox(width: 12),
                  _buildCircleActionIcon(Icons.more_horiz, () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildBadge("Active", const Color(0xFF2D68FF), Colors.white),
              const SizedBox(width: 8),
              _buildBadge("Day 8 of 22", Colors.white.withOpacity(0.6),
                  const Color(0xFF475467)),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "JAPAN DISCOVERY 2025",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475467),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tokyo · Kyoto · Osaka",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF475467), size: 22),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: _buildActionItem(
                Icons.list_alt_rounded, "Itinerary", Colors.blue)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildActionItem(
                Icons.account_balance_wallet_outlined, "Budget", Colors.teal)),
        const SizedBox(width: 8),
        Expanded(
            child:
                _buildActionItem(Icons.map_outlined, "Map", Colors.deepPurple)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildActionItem(
                Icons.chat_bubble_outline_rounded, "Chat", Colors.redAccent)),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min, // chỉ lấy diện tích cần thiết
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: color.withOpacity(0.2), //shadow theo màu của icon
          child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                //logic here
              },
              //effect
              child: SizedBox(
                  height: 60,
                  width: double.infinity, //lắp đầy expanded
                  child: Icon(
                    icon,
                    color: color,
                    size: 26,
                  ))),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5)),
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TRIP INFO",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20)),
                child: _buildBadge(
                    "PLANNED", Colors.transparent, const Color(0xFF2D68FF)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Sử dụng Wrap hoặc Row để chia cột
          Row(
            children: [
              _buildInfoColumn(
                  Icons.calendar_today_rounded, "Dates", "Apr 12 – May 3"),
              _buildInfoColumn(Icons.timer_outlined, "Duration", "22 days"),
            ],
          ),
          const SizedBox(height: 16),
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
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }

  Widget _buildCollaboratorsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "COLLABORATORS",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              _buildTextButton("Invite"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildAvatar("AJ", const Color(0xFF2D68FF)),
              const SizedBox(width: 8),
              _buildAvatar("SK", const Color(0xFF8B5CF6)),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: _buildAddButton(() {
                  //add member here
                }),
              ),
              const SizedBox(width: 12),
              const Text("2 members",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String text, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onTap) {
    return Material(
      color: Colors.transparent, // Nền trong suốt để thấy viền
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(), // Giúp hiệu ứng ripple hình tròn
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade50, // Màu nền cực nhạt
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300, // Màu viền mảnh
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 20,
            color: Colors.grey, // Màu icon
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "BUDGET OVERVIEW",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              _buildTextButton("Add expense"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Spent \$1,842",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Text("44% of \$4,200",
                  style: TextStyle(color: Colors.grey[400], fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.44,
              minHeight: 12,
              backgroundColor: Color(0xFFF2F5FF),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D68FF)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.grey[200]!),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Full budget tracker",
                style: TextStyle(
                    color: Color(0xFF101828), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String title) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero, minimumSize: Size.zero),
      child: Text(title,
          style:
              TextStyle(color: Color(0xFF2D68FF), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeatherAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE1E1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFD92D20), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Heavy rain — Apr 16–17",
                  style: TextStyle(
                      color: Color(0xFFB42318),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style:
                        const TextStyle(color: Color(0xFFB42318), fontSize: 12),
                    children: [
                      const TextSpan(
                          text: "AI rescheduled 3 outdoor activities. "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            //Logic here
                          },
                          child: const Text(
                            "See forecast →",
                            style: TextStyle(
                                color: Color(0xFF2D68FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
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
