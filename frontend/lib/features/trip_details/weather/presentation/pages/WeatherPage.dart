import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

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
                _buildCurrentWeatherCard(),
                const SizedBox(height: 25),
                _buildSectionHeader("ACTIVE ALERTS", null),
                const SizedBox(height: 15),
                _buildAlertCard(
                  icon: Icons.warning_amber_rounded,
                  title: "Heavy rain — Apr 16–17",
                  message:
                      "120mm expected. AI rescheduled 3 outdoor activities automatically.",
                  color: const Color(0xFFD92D20),
                  bgColor: const Color(0xFFFFF1F1),
                ),
                const SizedBox(height: 12),
                _buildAlertCard(
                  icon: Icons.air_rounded,
                  title: "Wind advisory — Apr 19",
                  message:
                      "Gusts 60 km/h near coastal areas. Miyajima ferry postponed.",
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFFFBEB),
                ),
                const SizedBox(height: 25),
                _buildSectionHeader("7-DAY FORECAST", "Details"),
                const SizedBox(height: 15),
                _buildForecastList(),
                const SizedBox(height: 25),
                _buildSectionHeader("PRECIPITATION PROBABILITY", null),
                const SizedBox(height: 15),
                _buildPrecipitationChart(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 1. Background đồng bộ với Template
  BoxDecoration _buildBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Colors.white],
      ),
    );
  }

// 2. Header đồng bộ (Back button + Title)
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
          "Weather Alerts",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101828),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

// 3. Section Header đồng bộ
  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2)),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: Text(
              actionText,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D68FF)),
            ),
          ),
      ],
    );
  }

// 4. Current Weather Card (Premium look)
  Widget _buildCurrentWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on_rounded,
                      size: 16, color: Color(0xFF2D68FF)),
                  SizedBox(width: 6),
                  Text("Kyoto, Japan",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF667085))),
                ],
              ),
              const SizedBox(height: 10),
              const Text("18°c",
                  style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF101828))),
              const Text("Partly cloudy",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828))),
            ],
          ),
          const Positioned(
            right: 0,
            top: 10,
            child: Icon(Icons.cloud_circle_outlined,
                size: 80, color: Colors.orangeAccent),
          )
        ],
      ),
    );
  }

// 5. Alert Card (Styled like notification)
  Widget _buildAlertCard(
      {required IconData icon,
      required String title,
      required String message,
      required Color color,
      required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 4),
                Text(message,
                    style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.8),
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

// 6. Horizontal Forecast List
  Widget _buildForecastList() {
    final List<Map<String, dynamic>> forecast = [
      {
        "day": "Today",
        "icon": Icons.wb_cloudy_rounded,
        "high": "18°",
        "low": "11°"
      },
      {
        "day": "Fri",
        "icon": Icons.wb_sunny_rounded,
        "high": "22°",
        "low": "13°"
      },
      {
        "day": "Sat",
        "icon": Icons.beach_access_rounded,
        "high": "14°",
        "low": "10°",
        "active": true
      },
      {
        "day": "Sun",
        "icon": Icons.beach_access_rounded,
        "high": "13°",
        "low": "9°"
      },
      {
        "day": "Mon",
        "icon": Icons.wb_cloudy_rounded,
        "high": "16°",
        "low": "10°"
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: forecast.map((item) {
          bool isActive = item['active'] ?? false;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF2D68FF) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isActive)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Text(item['day'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFF667085))),
                const SizedBox(height: 12),
                Icon(item['icon'],
                    color: isActive ? Colors.white : Colors.orangeAccent,
                    size: 28),
                const SizedBox(height: 12),
                Text(item['high'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFF101828))),
                Text(item['low'],
                    style: TextStyle(
                        fontSize: 12,
                        color: isActive
                            ? Colors.white70
                            : const Color(0xFF98A2B3))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

// 7. Precipitation Chart Card
  Widget _buildPrecipitationChart() {
    final List<Map<String, dynamic>> data = [
      {"day": "Thu", "value": 15},
      {"day": "Fri", "value": 5},
      {"day": "Sat", "value": 90},
      {"day": "Sun", "value": 85},
      {"day": "Mon", "value": 40},
      {"day": "Tue", "value": 10},
      {"day": "Wed", "value": 5},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          double height = item['value'].toDouble();
          bool isHigh = height > 50;
          return Column(
            children: [
              Text("${item['value']}%",
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828))),
              const SizedBox(height: 8),
              Container(
                width: 35,
                height: height * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isHigh
                        ? [const Color(0xFF2D68FF), const Color(0xFF8B5CF6)]
                        : [Colors.grey[300]!, Colors.grey[200]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Text(item['day'],
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
