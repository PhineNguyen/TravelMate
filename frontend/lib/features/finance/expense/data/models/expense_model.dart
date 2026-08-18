import 'dart:math' as math;

class ExpenseModel {
  final int? id;
  final int? tripId;
  final int? createdById;
  final double amount;
  final String category;
  final String description;
  final DateTime? expenseDate;
  final bool isShared;
  final bool isDeleted;
  final DateTime? createdAt;

  const ExpenseModel({
    this.id,
    this.tripId,
    this.createdById,
    required this.amount,
    required this.category,
    required this.description,
    this.expenseDate,
    this.isShared = false,
    this.isDeleted = false,
    this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: (json['id'] as num?)?.toInt(),
      tripId: (json['tripId'] as num?)?.toInt(),
      createdById: (json['createdById'] as num?)?.toInt(),
      amount: _parseDouble(json['amount']),
      category: (json['category'] as String?) ?? 'OTHER',
      description: (json['description'] as String?) ?? '',
      expenseDate: _parseDateTime(json['expenseDate']),
      isShared: (json['isShared'] as bool?) ?? false,
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String get categoryLabel => category.toUpperCase();

  String get amountLabel => '\$${amount.toStringAsFixed(0)}';
}
