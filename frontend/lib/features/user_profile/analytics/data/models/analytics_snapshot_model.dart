class AnalyticsSnapshotModel {
  final int? id;
  final int? tripId;
  final int? totalTrips;
  final double? avgBudget;
  final double? totalSpent;
  final String? favoriteCategory;
  final String? mostVisitedDestination;
  final String? travelPersonality;
  final DateTime? generatedAt;

  const AnalyticsSnapshotModel({
    this.id,
    this.tripId,
    this.totalTrips,
    this.avgBudget,
    this.totalSpent,
    this.favoriteCategory,
    this.mostVisitedDestination,
    this.travelPersonality,
    this.generatedAt,
  });

  factory AnalyticsSnapshotModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsSnapshotModel(
      id: (json['id'] as num?)?.toInt(),
      tripId: (json['tripId'] as num?)?.toInt(),
      totalTrips: (json['totalTrips'] as num?)?.toInt() ?? 0,
      avgBudget: _parseDouble(json['avgBudget']),
      totalSpent: _parseDouble(json['totalSpent']),
      favoriteCategory: json['favoriteCategory'] as String?,
      mostVisitedDestination: json['mostVisitedDestination'] as String?,
      travelPersonality: json['travelPersonality'] as String?,
      generatedAt: _parseDateTime(json['generatedAt']),
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
