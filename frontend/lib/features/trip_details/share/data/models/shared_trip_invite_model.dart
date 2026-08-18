class SharedTripInviteModel {
  final int? id;
  final int? tripId;
  final int? senderId;
  final String? receiverEmail;
  final String? inviteCode;
  final String? status;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const SharedTripInviteModel({
    this.id,
    this.tripId,
    this.senderId,
    this.receiverEmail,
    this.inviteCode,
    this.status,
    this.expiresAt,
    this.createdAt,
  });

  factory SharedTripInviteModel.fromJson(Map<String, dynamic> json) {
    return SharedTripInviteModel(
      id: (json['id'] as num?)?.toInt(),
      tripId: (json['tripId'] as num?)?.toInt(),
      senderId: (json['senderId'] as num?)?.toInt(),
      receiverEmail: json['receiverEmail'] as String?,
      inviteCode: json['inviteCode'] as String?,
      status: (json['status'] as String?) ?? 'PENDING',
      expiresAt: _parseDateTime(json['expiresAt']),
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
