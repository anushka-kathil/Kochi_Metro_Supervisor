import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kochi_metro_supervisor/core/constants/app_constants.dart';
import '../models/notification_model.dart';

class NotificationServices {
  static const String baseUrl =
      AppConstants.baseUrl; // Replace with your API base URL

  Future<NotificationResponse> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return NotificationResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/notifications/mark-all-read'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }
}
