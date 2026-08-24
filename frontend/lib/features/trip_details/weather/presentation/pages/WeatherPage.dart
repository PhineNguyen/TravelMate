import 'package:flutter/material.dart';

import '../../../../../core/location/location_service.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/widgets/app_header.dart';
import '../../data/models/weather_alert_model.dart';
import '../../data/models/weather_forecast_model.dart';
import '../../data/models/weather_snapshot_model.dart';
import '../../data/models/current_weather_model.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final int? tripId;

  const WeatherPage({super.key, this.onBackToHome, this.tripId});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool _isLoading = true;
  String? _error;
  WeatherSnapshotModel? _snapshot;
  CurrentWeatherModel? _gpsWeather;
  List<WeatherAlertModel> _alerts = [];
  List<WeatherForecastModel> _forecast = [];

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
      final position = await LocationService.getCurrentPosition();
      final gpsWeather = await ApiClient.fetchCurrentWeatherByGps(
        position.latitude,
        position.longitude,
      );

      WeatherSnapshotModel? snapshot;
      List<WeatherAlertModel> alerts = [];
      List<WeatherForecastModel> forecast = [];
      final tripId = widget.tripId;
      if (tripId != null) {
        final results = await Future.wait([
          ApiClient.fetchWeatherSnapshot(tripId),
          ApiClient.fetchWeatherAlerts(tripId),
          ApiClient.fetchWeatherForecast(tripId),
        ]);
        snapshot = results[0] as WeatherSnapshotModel?;
        alerts = results[1] as List<WeatherAlertModel>;
        forecast = results[2] as List<WeatherForecastModel>;
      }

      if (!mounted) return;
      setState(() {
        _gpsWeather = gpsWeather;
        _snapshot = snapshot;
        _alerts = alerts;
        _forecast = forecast;
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
    final city = _gpsWeather?.city ?? _snapshot?.city ?? "Đang cập nhật...";
    final temp = _gpsWeather?.temperature.toStringAsFixed(0) ??
        _snapshot?.temperature.toStringAsFixed(0) ??
        "--";
    final condition =
        _gpsWeather?.condition ?? _snapshot?.condition ?? "Chưa có dữ liệu";

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
              const SizedBox(height: 24),
              Wrap(
                spacing: 18,
                runSpacing: 14,
                children: [
                  _buildWeatherMetric(
                    Icons.water_drop_outlined,
                    "Humidity",
                    "${(_gpsWeather?.humidity ?? _snapshot?.humidity)?.toStringAsFixed(0) ?? '--'}%",
                  ),
                  _buildWeatherMetric(
                    Icons.air,
                    "Wind",
                    "${(_gpsWeather?.windSpeed ?? _snapshot?.windSpeed)?.toStringAsFixed(1) ?? '--'} m/s",
                  ),
                  _buildWeatherMetric(
                    Icons.umbrella_outlined,
                    "Rain",
                    "${(_gpsWeather?.rainProbability ?? _snapshot?.rainProbability)?.toStringAsFixed(0) ?? '--'}%",
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Icon(_getWeatherIcon(condition),
                size: 100, color: Colors.blue.shade200),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherMetric(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2D7132)),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF71768E))),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D2D))),
          ],
        ),
      ],
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
    if (_forecast.isEmpty) {
      return const Text("Không có dữ liệu dự báo.",
          style: TextStyle(color: Color(0xFF71768E)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _forecast.map((item) {
          final isActive = _isSameDay(item.date, DateTime.now());
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
                Text(_formatForecastDay(item.date),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFFB0B3C1))),
                const SizedBox(height: 15),
                Icon(_getWeatherIcon(item.condition),
                    color: isActive ? Colors.white : Colors.orange.shade700,
                    size: 32),
                const SizedBox(height: 15),
                Text('${item.temperatureHigh.toStringAsFixed(0)}°',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isActive ? Colors.white : const Color(0xFF1A1D2D))),
                Text('${item.temperatureLow.toStringAsFixed(0)}°',
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

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _formatForecastDay(DateTime date) {
    if (_isSameDay(date, DateTime.now())) return "Today";
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[date.weekday - 1];
  }

  IconData _getWeatherIcon(String condition) {
    final value = condition.toLowerCase();
    if (value.contains("thunder") || value.contains("storm")) {
      return Icons.thunderstorm_rounded;
    }
    if (value.contains("rain") ||
        value.contains("drizzle") ||
        value.contains("mưa")) {
      return Icons.water_drop_rounded;
    }
    if (value.contains("cloud") || value.contains("mây")) {
      return Icons.cloud_rounded;
    }
    if (value.contains("clear") ||
        value.contains("sun") ||
        value.contains("nắng")) {
      return Icons.wb_sunny_rounded;
    }
    return Icons.cloud_queue_rounded;
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
