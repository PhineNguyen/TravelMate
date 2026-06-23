import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_header.dart';

class WeatherPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const WeatherPage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FA),
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
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
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
                    child: const Icon(Icons.more_vert_rounded,
                        color: Color(0xFF1A1D2D), size: 20),
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
                      color: const Color(0xFFD32F2F),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(
                      icon: Icons.air_rounded,
                      title: "Wind advisory — Apr 19",
                      message:
                          "Gusts 60 km/h near coastal areas. Miyajima ferry postponed.",
                      color: Colors.orange.shade800,
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
          Icon(icon, color: const Color(0xFF1A1D2D), size: 18),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Color(0xFF1A1D2D), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71768E),
                letterSpacing: 1.2)),
        if (actionText != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 16, color: Color(0xFF2D7132)),
                  const SizedBox(width: 8),
                  const Text("Kyoto, Japan",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF71768E))),
                ],
              ),
              const SizedBox(height: 15),
              const Text("18°c",
                  style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF1A1D2D))),
              const Text("Partly cloudy",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D2D))),
            ],
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Icon(Icons.wb_twilight_rounded,
                size: 100, color: Colors.orange.shade400),
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
        border: Border.all(color: color.withOpacity(0.1)),
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
                        color: Color(0xFF1A1D2D))),
                const SizedBox(height: 6),
                Text(message,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF71768E), height: 1.5)),
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
              color: isActive ? const Color(0xFF2D7132) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isActive
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              children: [
                Text(item['day'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFFB0B3C1))),
                const SizedBox(height: 15),
                Icon(item['icon'],
                    color: isActive ? Colors.white : Colors.orange.shade700,
                    size: 32),
                const SizedBox(height: 15),
                Text(item['high'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFF1A1D2D))),
                Text(item['low'],
                    style: TextStyle(
                        fontSize: 12,
                        color: isActive
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFFB0B3C1))),
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
                          ? const Color(0xFF2D7132)
                          : const Color(0xFFB0B3C1))),
              const SizedBox(height: 10),
              Container(
                width: 32,
                height: height * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isHigh
                        ? [const Color(0xFF2D7132), const Color(0xFF8BC34A)]
                        : [const Color(0xFFF1F4FA), const Color(0xFFE2E4EB)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Text(item['day'],
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB0B3C1),
                      fontWeight: FontWeight.bold)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
