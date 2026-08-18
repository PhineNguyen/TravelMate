// Cung cap cac ham ma hoa va giai ma du lieu JSON.
import 'dart:convert';

// Xac dinh ung dung dang chay tren Web hay tren mobile/desktop.
import 'package:flutter/foundation.dart';

// Thu vien HTTP dung de gui request den backend Spring Boot.
import 'package:http/http.dart' as http;
import 'package:frontend/core/auth/session_service.dart';

// Cac model dung de chuyen JSON response thanh object Dart.
import '../../features/finance/expense/data/models/expense_model.dart';
import '../../features/trip_details/share/data/models/shared_trip_invite_model.dart';
import '../../features/trip_planning/home/data/models/trip_model.dart';
import '../../features/trip_planning/templates/data/models/trip_template_model.dart';
import '../../features/user_profile/analytics/data/models/analytics_snapshot_model.dart';
import '../../features/user_profile/notifications/data/models/notification_model.dart';

class ApiClient {
  // Web/desktop dung localhost; Android Emulator dung 10.0.2.2 de truy cap may host.
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  // Token dang nhap duoc gan sau khi login/register thanh cong.
  static String? accessToken;

  static Future<void> restoreSession() async {
    accessToken = SessionService.token;
  }

  static Future<void> clearSession() async {
    accessToken = null;
    await SessionService.clear();
  }

  static Map<String, String> _headers() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  static dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  static void _requireStatus(http.Response response, Set<int> accepted) {
    if (!accepted.contains(response.statusCode)) {
      throw Exception(
        'API request failed. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  // Chuan hoa cac dang response danh sach: List truc tiep hoac Page/content/data/items.
  static List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      for (final key in ['content', 'data', 'items']) {
        final value = decoded[key];
        if (value is List) return value;
      }
    }
    return const <dynamic>[];
  }

  // Lay danh sach chuyen di tu endpoint /api/trips.
  static Future<List<TripModel>> fetchTrips() async {
    final uri = Uri.parse('$baseUrl/api/trips');

    // Gui GET request kem header bao backend tra ve JSON.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Bao loi neu backend khong tra ve HTTP 200.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load trips. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Giai ma response va chuyen tung phan tu thanh TripModel.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) => TripModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay danh sach mau chuyen di tu endpoint /api/trip-templates.
  static Future<List<TripTemplateModel>> fetchTripTemplates() async {
    final uri = Uri.parse('$baseUrl/api/trip-templates');

    // Gui request doc du lieu template tu backend.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Khong cho phep ung dung tiep tuc voi response loi.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load trip templates. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Chuyen JSON response thanh danh sach TripTemplateModel.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) =>
            TripTemplateModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay danh sach thong bao cua nguoi dung.
  static Future<List<NotificationModel>> fetchNotifications() async {
    final uri = Uri.parse('$baseUrl/api/notifications');

    // Goi API notifications bang phuong thuc GET.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Nem exception de man hinh co the hien thi trang thai that bai.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load notifications. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Parse JSON thanh cac model thong bao.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) =>
            NotificationModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay cac ban chup thong ke du lich tu backend.
  static Future<List<AnalyticsSnapshotModel>> fetchAnalyticsSnapshots() async {
    final uri = Uri.parse('$baseUrl/api/analytics-snapshots');

    // Gui request doc du lieu analytics.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Kiem tra ket qua request truoc khi parse du lieu.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load analytics snapshots. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Chuyen du lieu JSON thanh AnalyticsSnapshotModel.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) =>
            AnalyticsSnapshotModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay danh sach loi moi chia se chuyen di.
  static Future<List<SharedTripInviteModel>> fetchSharedTripInvites() async {
    final uri = Uri.parse('$baseUrl/api/shared-trip-invites');

    // Goi API invite de hien thi loi moi va trang thai cua chung.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Bao loi neu khong the tai danh sach invite.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load trip invites. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Parse tung invite JSON thanh SharedTripInviteModel.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) =>
            SharedTripInviteModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay danh sach chi tieu; co the loc theo mot tripId cu the.
  static Future<List<ExpenseModel>> fetchExpenses({int? tripId}) async {
    // Chi them query parameter khi man hinh yeu cau chi tieu cua mot trip.
    final queryParams = <String, String>{};
    if (tripId != null) queryParams['tripId'] = tripId.toString();

    final uri = Uri.parse('$baseUrl/api/expenses').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    // Gui request lay chi tieu theo bo loc da tao.
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Kiem tra loi HTTP truoc khi doc noi dung response.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load expenses. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }

    // Chuyen JSON response thanh danh sach ExpenseModel.
    final decoded = jsonDecode(response.body);
    final data = _extractList(decoded);
    return data
        .map((item) => ExpenseModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Lay chi tiet mot chuyen di.
  static Future<TripModel> fetchTrip(int tripId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/trips/$tripId'),
      headers: _headers(),
    );
    _requireStatus(response, {200});
    return TripModel.fromJson(Map<String, dynamic>.from(_decodeBody(response)));
  }

  // Tao chuyen di moi tu form Create Trip.
  static Future<TripModel> createTrip({
    required int ownerId,
    required String destination,
    required String startDate,
    required int duration,
    required int travelerCount,
    required double totalBudget,
    int? templateId,
    String planningMode = 'MANUAL',
    String tripStatus = 'DRAFT',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/trips'),
      headers: _headers(),
      body: jsonEncode({
        'ownerId': ownerId,
        'destination': destination,
        'startDate': startDate,
        'duration': duration,
        'travelerCount': travelerCount,
        'totalBudget': totalBudget,
        'planningMode': planningMode,
        'tripStatus': tripStatus,
        if (templateId != null) 'templateId': templateId,
        'isCustomized': true,
      }),
    );
    _requireStatus(response, {200, 201});
    return TripModel.fromJson(Map<String, dynamic>.from(_decodeBody(response)));
  }

  // Xoa mem chuyen di.
  static Future<void> deleteTrip(int tripId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/trips/$tripId'),
      headers: _headers(),
    );
    _requireStatus(response, {204});
  }

  // Tao khoan chi moi.
  static Future<ExpenseModel> createExpense({
    required int tripId,
    required int createdById,
    required double amount,
    required String category,
    String? description,
    String? expenseDate,
    bool isShared = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/expenses'),
      headers: _headers(),
      body: jsonEncode({
        'tripId': tripId,
        'createdById': createdById,
        'amount': amount,
        'category': category,
        'description': description,
        'expenseDate': expenseDate ?? DateTime.now().toIso8601String().substring(0, 10),
        'isShared': isShared,
      }),
    );
    _requireStatus(response, {200, 201});
    return ExpenseModel.fromJson(Map<String, dynamic>.from(_decodeBody(response)));
  }

  // Xoa mem khoan chi.
  static Future<void> deleteExpense(int expenseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/expenses/$expenseId'),
      headers: _headers(),
    );
    _requireStatus(response, {204});
  }

  // Tao loi moi chia se chuyen di.
  static Future<SharedTripInviteModel> createInvite({
    required int tripId,
    required int senderId,
    required String receiverEmail,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/shared-trip-invites'),
      headers: _headers(),
      body: jsonEncode({
        'tripId': tripId,
        'senderId': senderId,
        'receiverEmail': receiverEmail,
      }),
    );
    _requireStatus(response, {200, 201});
    return SharedTripInviteModel.fromJson(
        Map<String, dynamic>.from(_decodeBody(response)));
  }

  // Danh dau mot thong bao da doc.
  static Future<void> markNotificationRead(int notificationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
      headers: _headers(),
    );
    _requireStatus(response, {200});
  }

  // Danh dau tat ca thong bao da doc.
  static Future<void> markAllNotificationsRead() async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/notifications/read-all'),
      headers: _headers(),
    );
    _requireStatus(response, {204});
  }

  // Dang nhap va luu access token cho request tiep theo.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    _requireStatus(response, {200});
    final result = Map<String, dynamic>.from(_decodeBody(response));
    accessToken = result['accessToken'] as String?;
    return result;
  }

  // Dang ky tai khoan moi.
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: _headers(),
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      }),
    );
    _requireStatus(response, {200, 201});
    final result = Map<String, dynamic>.from(_decodeBody(response));
    accessToken = result['accessToken'] as String?;
    return result;
  }

}
