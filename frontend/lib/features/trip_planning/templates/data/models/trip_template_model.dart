class TripTemplateModel {
  final int? id;
  final String? title;
  final String? destination;
  final String? category;
  final int? duration;
  final double? estimatedBudget;
  final String? thumbnailUrl;
  final String? description;
  final double? popularityScore;
  final DateTime? createdAt;

  const TripTemplateModel({
    this.id,
    this.title,
    this.destination,
    this.category,
    this.duration,
    this.estimatedBudget,
    this.thumbnailUrl,
    this.description,
    this.popularityScore,
    this.createdAt,
  });

  factory TripTemplateModel.fromJson(Map<String, dynamic> json) {
    return TripTemplateModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String? ?? 'Trip Template',
      destination: json['destination'] as String? ?? 'Unknown destination',
      category: json['category'] as String? ?? 'General',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      estimatedBudget: _parseDouble(json['estimatedBudget']),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      description: json['description'] as String?,
      popularityScore: _parseDouble(json['popularityScore']),
      createdAt: _parseDateTime(json['createdAt']),
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
