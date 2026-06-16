import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackground(), // Đồng bộ gradient nền
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 15),
                _buildMapViewCard(), // Bản đồ dạng Card bo góc
                const SizedBox(height: 25),
                _buildSectionHeader("OPTIMISED SEGMENTS", "JR Pass"),
                const SizedBox(height: 15),
                // Danh sách các chặng đi
                _buildSegmentCard(
                  icon: Icons.train_rounded,
                  fromTo: "Osaka → Kyoto",
                  subTitle: "Shinkansen bullet train · 15 min",
                  distance: "15 km",
                  color: const Color(0xFF12927F),
                ),
                _buildSegmentCard(
                  icon: Icons.train_rounded,
                  fromTo: "Kyoto → Mt. Fuji",
                  subTitle: "JR Limited Express · 2h 20min",
                  distance: "340 km",
                  color: const Color(0xFF2D68FF),
                ),
                _buildSegmentCard(
                  icon: Icons.train_rounded,
                  fromTo: "Mt. Fuji → Tokyo",
                  subTitle: "Limited Express Fujisan · 2h 5min",
                  distance: "105 km",
                  color: const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 10),
                _buildNavigationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Background đồng bộ với TemplatePage
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
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF101828),
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Route Optimisation",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101828),
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        // Badge "Optimised" thay cho nút tune
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F9F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: Color(0xFF12927F), size: 16),
              SizedBox(width: 4),
              Text(
                "Optimised",
                style: TextStyle(
                  color: Color(0xFF12927F),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. Section Header đồng bộ
  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2)),
        Text(
          actionText,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D68FF)),
        ),
      ],
    );
  }

  // 4. Bản đồ được bọc trong Card trắng bo góc
  Widget _buildMapViewCard() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: GridPainter()),
            CustomPaint(size: Size.infinite, painter: DashLinePainter()),
            _buildMapMarker(220, 40, "Osaka", const Color(0xFF12927F)),
            _buildMapMarker(150, 110, "Kyoto", const Color(0xFFD97706)),
            _buildMapMarker(90, 180, "Mt. Fuji", const Color(0xFF8B5CF6)),
            _buildMapMarker(40, 250, "Tokyo ★", const Color(0xFF2D68FF)),
            // Save time label
            Positioned(
              bottom: 15,
              right: 15,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Save 4h 20min",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(double top, double left, String label, Color color) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Icon(Icons.location_on_rounded, color: color, size: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Text(label,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 5. Card chặng đi đồng bộ với TemplateCard
  Widget _buildSegmentCard({
    required IconData icon,
    required String fromTo,
    required String subTitle,
    required String distance,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromTo,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828)),
                ),
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            distance,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.navigation_rounded),
        label: const Text("Start Navigation",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12927F),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
      ),
    );
  }
}

// --- Các lớp vẽ (Giữ nguyên logic của bạn) ---

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0;
    const double step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D68FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(55, 220); // Osaka
    path.lineTo(125, 150); // Kyoto
    path.lineTo(195, 90); // Mt Fuji
    path.lineTo(265, 40); // Tokyo

    double dashWidth = 5, dashSpace = 4, distance = 0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
