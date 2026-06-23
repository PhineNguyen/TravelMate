import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildMapViewCard(),
              const SizedBox(height: 30),
              _buildSectionHeader("OPTIMISED SEGMENTS", "JR Pass"),
              const SizedBox(height: 15),
              _buildSegmentCard(
                icon: Icons.train_rounded,
                fromTo: "Osaka → Kyoto",
                subTitle: "Shinkansen bullet train · 15 min",
                distance: "15 km",
                color: const Color(0xFF2D7132),
              ),
              _buildSegmentCard(
                icon: Icons.train_rounded,
                fromTo: "Kyoto → Mt. Fuji",
                subTitle: "JR Limited Express · 2h 20min",
                distance: "340 km",
                color: Colors.blue.shade700,
              ),
              _buildSegmentCard(
                icon: Icons.train_rounded,
                fromTo: "Mt. Fuji → Tokyo",
                subTitle: "Limited Express Fujisan · 2h 5min",
                distance: "105 km",
                color: Colors.purple.shade700,
              ),
              const SizedBox(height: 30),
              _buildNavigationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back,
                color: Color(0xFF1A1D2D), size: 20),
          ),
        ),
        const SizedBox(width: 15),
        const Text(
          "Route Optimisation",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1D2D),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D7132).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: Color(0xFF2D7132), size: 16),
              SizedBox(width: 6),
              Text(
                "Optimised",
                style: TextStyle(
                  color: Color(0xFF2D7132),
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

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.2)),
        Text(
          actionText,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D7132)),
        ),
      ],
    );
  }

  Widget _buildMapViewCard() {
    return Container(
      height: 340,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: GridPainter()),
            CustomPaint(size: Size.infinite, painter: DashLinePainter()),
            _buildMapMarker(220, 40, "Osaka", const Color(0xFF2D7132)),
            _buildMapMarker(150, 110, "Kyoto", Colors.orange.shade700),
            _buildMapMarker(90, 180, "Mt. Fuji", Colors.purple.shade700),
            _buildMapMarker(40, 250, "Tokyo ★", Colors.blue.shade700),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D2D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Save 4h 20min",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
          Icon(Icons.location_on_rounded, color: color, size: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                )
              ],
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentCard({
    required IconData icon,
    required String fromTo,
    required String subTitle,
    required String distance,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D2D)),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style:
                      const TextStyle(color: Color(0xFF71768E), fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            distance,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF2D7132),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D7132).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.navigation_rounded, size: 22, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Start Navigation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
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
      ..color = const Color(0xFF2D7132)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(55, 220); // Osaka
    path.lineTo(125, 150); // Kyoto
    path.lineTo(195, 90); // Mt Fuji
    path.lineTo(265, 40); // Tokyo

    double dashWidth = 8, dashSpace = 6, distance = 0;
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
