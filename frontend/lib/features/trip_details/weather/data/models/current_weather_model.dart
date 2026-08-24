class CurrentWeatherModel {
  final double latitude;
  final double longitude;
  final String city;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double rainProbability;
  final String condition;
  final bool isOutdoorSafe;
  final DateTime? providerRecordedAt;

  const CurrentWeatherModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.condition,
    required this.isOutdoorSafe,
    this.providerRecordedAt,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      city: json['city'] as String? ?? 'Unknown',
      temperature: _parseDouble(json['temperature']),
      humidity: _parseDouble(json['humidity']),
      windSpeed: _parseDouble(json['windSpeed']),
      rainProbability: _parseDouble(json['rainProbability']),
      condition: json['condition'] as String? ?? 'Unknown',
      isOutdoorSafe: json['isOutdoorSafe'] as bool? ?? true,
      providerRecordedAt: DateTime.tryParse(
        json['providerRecordedAt']?.toString() ?? '',
      ),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
