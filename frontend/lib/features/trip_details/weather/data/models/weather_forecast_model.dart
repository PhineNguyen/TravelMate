class WeatherForecastModel {
  final DateTime date;
  final double temperatureHigh;
  final double temperatureLow;
  final String condition;
  final double humidity;
  final double windSpeed;
  final double rainProbability;
  final bool isOutdoorSafe;

  const WeatherForecastModel({
    required this.date,
    required this.temperatureHigh,
    required this.temperatureLow,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.isOutdoorSafe,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      temperatureHigh: _parseDouble(json['temperatureHigh']),
      temperatureLow: _parseDouble(json['temperatureLow']),
      condition: json['condition'] as String? ?? 'Unknown',
      humidity: _parseDouble(json['humidity']),
      windSpeed: _parseDouble(json['windSpeed']),
      rainProbability: _parseDouble(json['rainProbability']),
      isOutdoorSafe: json['isOutdoorSafe'] as bool? ?? true,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
