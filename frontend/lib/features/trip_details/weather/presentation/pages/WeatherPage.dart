import 'package:flutter/material.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/widgets/app_header.dart';
import '../../data/models/weather_alert_model.dart';
import '../../data/models/weather_snapshot_model.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final int tripId; // Nhận tripId để biết đang xem thời tiết của chuyến đi nào

  const WeatherPage({super.key, this.onBackToHome, this.tripId = 1});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool _isLoading = true;
  String? _error;
  WeatherSnapshotModel? _snapshot;
  List<WeatherAlertModel> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  // Hàm gọi API lấy dữ liệu thời tiết
  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Chạy cả 2 API cùng lúc cho nhanh
      final results = await Future.wait([
        ApiClient.fetchWeatherSnapshot(widget.tripId),
        ApiClient.fetchWeatherAlerts(widget.tripId),
      ]);

      if (!mounted) return;
      setState(() {
        _snapshot = results[0] as WeatherSnapshotModel?;
        _alerts = results[1] as List<WeatherAlertModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
                onBack: widget.onBackToHome ?? () => Navigator.pop(context),
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
                  onSelected: (value) {
                    if (value == "Refresh data") {
                      _loadWeatherData(); // Bấm refresh thì tải lại dữ liệu
                    }
                  },
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text('Lỗi: $_error'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCurrentWeatherCard(),
                              const SizedBox(height: 30),
                              _buildSectionHeader("ACTIVE ALERTS", null),
                              const SizedBox(height: 15),

                              // HIỂN THỊ DANH SÁCH CẢNH BÁO TỪ API
                              if (_alerts.isEmpty)
                                const Text("Không có cảnh báo thời tiết nào.",
                                    style: TextStyle(color: Color(0xFF71768E))),
                              for (var alert in _alerts) ...[
                                _buildAlertCard(
                                  icon: _getIconForSeverity(alert.severity),
                                  title: alert.alertType,
                                  message: alert.suggestedAction.isNotEmpty
                                      ? alert.suggestedAction
                                      : "Hãy chú ý thời tiết.",
                                  color: _getColorForSeverity(alert.severity),
                                ),
                                const SizedBox(height: 12),
                              ],

                              const SizedBox(height: 30),
                              _buildSectionHeader("7-DAY FORECAST", "Details"),
                              const SizedBox(height: 15),
                              _buildForecastList(),
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
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D7132)),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentWeatherCard() {
    // Nếu chưa có snapshot, hiển thị mặc định
    final city = _snapshot?.city ?? "Đang cập nhật...";
    final temp = _snapshot?.temperature.toStringAsFixed(0) ?? "--";
    final condition = _snapshot?.condition ?? "Chưa có dữ liệu";

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
                  Text(city,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF71768E))),
                ],
              ),
              const SizedBox(height: 15),
              Text("$temp°",
                  style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF1A1D2D))),
              Text(condition,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D2D))),
            ],
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Icon(Icons.wb_cloudy_rounded,
                size: 100, color: Colors.blue.shade200),
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
    // Chỗ này bạn có thể giữ nguyên mock data hoặc mở rộng API để lấy dự báo 7 ngày sau
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

  // Hàm phụ trợ để đổi màu dựa theo mức độ cảnh báo (Severity)
  Color _getColorForSeverity(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return const Color(0xFFD32F2F); // Đỏ
      case 'MEDIUM':
      case 'WARNING':
        return Colors.orange.shade800; // Cam
      default:
        return Colors.blue.shade700; // Xanh thông báo
    }
  }

  // Hàm phụ trợ đổi icon dựa theo mức độ
  IconData _getIconForSeverity(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return Icons.warning_amber_rounded;
      case 'MEDIUM':
      case 'WARNING':
        return Icons.air_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
