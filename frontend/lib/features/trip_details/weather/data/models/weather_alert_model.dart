class WeatherAlertModel {
  final int id;
  final int tripId;
  final String alertType;
  final String severity;
  final String suggestedAction;
  final bool isResolved;
  final DateTime? createdAt;

  const WeatherAlertModel({
    required this.id,
    required this.tripId,
    required this.alertType,
    required this.severity,
    required this.suggestedAction,
    required this.isResolved,
    this.createdAt,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tripId: (json['tripId'] as num?)?.toInt() ?? 0,
      alertType: json['alertType'] as String? ?? 'GENERAL',
      severity: json['severity'] as String? ?? 'INFO',
      suggestedAction: json['suggestedAction'] as String? ?? '',
      isResolved: json['isResolved'] as bool? ?? false,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
