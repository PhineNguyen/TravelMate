class WeatherSnapshotModel {
  final int id;
  final int tripId;
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int rainProbability;
  final bool isOutdoorSafe;
  final DateTime? date;

  const WeatherSnapshotModel({
    required this.id,
    required this.tripId,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.isOutdoorSafe,
    this.date,
  });

  factory WeatherSnapshotModel.fromJson(Map<String, dynamic> json) {
    return WeatherSnapshotModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tripId: (json['tripId'] as num?)?.toInt() ?? 0,
      city: json['city'] as String? ?? 'Unknown',
      temperature: _parseDouble(json['temperature']),
      condition: json['condition'] as String? ?? 'Clear',
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: _parseDouble(json['windSpeed']),
      rainProbability: (json['rainProbability'] as num?)?.toInt() ?? 0,
      isOutdoorSafe: json['isOutdoorSafe'] as bool? ?? true,
      date: _parseDateTime(json['date']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
