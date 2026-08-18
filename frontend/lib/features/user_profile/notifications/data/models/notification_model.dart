class NotificationModel {
  final int? id;
  final int? userId;
  final String title;
  final String description;
  final String type;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.isRead,
    this.createdAt,
  });
  NotificationModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      title: (json['title'] as String?) ?? 'Notification',
      description:
          (json['body'] as String?) ?? (json['description'] as String?) ?? '',
      type: (json['type'] as String?) ?? 'GENERAL',
      isRead: (json['isRead'] as bool?) ?? false,
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
