import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class WeatherPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const WeatherPage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1423),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: AppHeader(
                title: "Weather Alerts",
                onBack: onBackToHome,
                trailing: PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: const Color(0xFF172234),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  itemBuilder: (context) => [
                    _buildPopupItem(Icons.refresh, "Refresh data"),
                    _buildPopupItem(
                        Icons.location_on_outlined, "Change location"),
                    _buildPopupItem(Icons.settings_outlined, "Alert settings"),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172234),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: const Icon(Icons.more_vert_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentWeatherCard(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("ACTIVE ALERTS", null),
                    const SizedBox(height: 15),
                    _buildAlertCard(
                      icon: Icons.warning_amber_rounded,
                      title: "Heavy rain — Apr 16–17",
                      message:
                          "120mm expected. AI rescheduled 3 outdoor activities automatically.",
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(
                      icon: Icons.air_rounded,
                      title: "Wind advisory — Apr 19",
                      message:
                          "Gusts 60 km/h near coastal areas. Miyajima ferry postponed.",
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(height: 30),
                    _buildSectionHeader("7-DAY FORECAST", "Details"),
                    const SizedBox(height: 15),
                    _buildForecastList(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("PRECIPITATION PROBABILITY", null),
                    const SizedBox(height: 15),
                    _buildPrecipitationChart(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
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

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 1.2)),
        if (actionText != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1ABC9C)),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 16, color: Color(0xFF1ABC9C)),
                  const SizedBox(width: 8),
                  Text("Kyoto, Japan",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500)),
                ],
              ),
              const SizedBox(height: 15),
              const Text("18°c",
                  style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      color: Colors.white)),
              const Text("Partly cloudy",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const Positioned(
            right: 0,
            top: 10,
            child: Icon(Icons.wb_twilight_rounded,
                size: 100, color: Colors.orangeAccent),
          )
        ],
      ),
    );
  }

  Widget _buildAlertCard(
      {required IconData icon,
      required String title,
      required String message,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text(message,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFF1ABC9C) : const Color(0xFF172234),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: isActive ? Colors.transparent : Colors.grey.shade800),
            ),
            child: Column(
              children: [
                Text(item['day'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF0B1423)
                            : Colors.grey.shade500)),
                const SizedBox(height: 15),
                Icon(item['icon'],
                    color: isActive
                        ? const Color(0xFF0B1423)
                        : Colors.orangeAccent,
                    size: 32),
                const SizedBox(height: 15),
                Text(item['high'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? const Color(0xFF0B1423) : Colors.white)),
                Text(item['low'],
                    style: TextStyle(
                        fontSize: 12,
                        color: isActive
                            ? const Color(0xFF0B1423).withOpacity(0.6)
                            : Colors.grey.shade600)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF172234),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800),
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
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isHigh
                          ? const Color(0xFF1ABC9C)
                          : Colors.grey.shade600)),
              const SizedBox(height: 10),
              Container(
                width: 32,
                height: height * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isHigh
                        ? [const Color(0xFF1ABC9C), Colors.tealAccent]
                        : [const Color(0xFF0B1423), Colors.grey.shade800],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Text(item['day'],
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
