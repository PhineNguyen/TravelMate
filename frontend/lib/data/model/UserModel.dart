class UserModel {
  final int id;
  final String email;
  final String fullname;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullname,
    required this.avatarUrl,
  });
  UserModel copyWith({
    int? id,
    String? email,
    String? fullname,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: (json['email'] as String?) ?? '',
      fullname: (json['fullname'] as String?) ?? '',
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
    );
  }
  String get initials {
    if (fullname.trim().isEmpty) return '?'; // Nếu tên trống, trả về dấu ?

// Tách tên thành các từ (ví dụ: "Alex Johnson" -> ["Alex", "Johnson"])
    List<String> nameParts = fullname.trim().split(' ');

    if (nameParts.length > 1) {
// Lấy chữ cái đầu của Tên và Họ (Ví dụ: Alex Johnson -> AJ)
      return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
          .toUpperCase();
    } else {
// Lấy 1 chữ cái đầu tiên nếu chỉ có 1 từ (Ví dụ: Alex -> A)
      return nameParts[0][0].toUpperCase();
    }
  }
}
