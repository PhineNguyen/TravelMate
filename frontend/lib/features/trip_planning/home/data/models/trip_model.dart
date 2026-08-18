class TripModel {
  final int id;
  final int ownerId;
  final String destination;
  final String startDate;
  final int duration;
  final int travelerCount;
  final double totalBudget;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TripModel({
    required this.id,
    required this.ownerId,
    required this.destination,
    required this.startDate,
    required this.duration,
    required this.travelerCount,
    required this.totalBudget,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ownerId: (json['ownerId'] as num?)?.toInt() ?? 0,
      destination: (json['destination'] as String?) ?? 'Unknown destination',
      startDate: (json['startDate'] as String?) ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      travelerCount: (json['travelerCount'] as num?)?.toInt() ?? 0,
      totalBudget: _parseDouble(json['totalBudget']),
      status: (json['tripStatus'] as String?) ?? 'DRAFT',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'destination': destination,
      'startDate': startDate,
      'duration': duration,
      'travelerCount': travelerCount,
      'totalBudget': totalBudget,
      'tripStatus': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
