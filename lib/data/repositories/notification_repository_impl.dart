import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationServices _services;

  NotificationRepositoryImpl(this._services);

  @override
  Future<NotificationResponse> getNotifications() async {
    try {
      return await _services.getNotifications();
    } catch (e) {
      throw Exception('Repository error: Failed to get notifications - $e');
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      return await _services.markAsRead(notificationId);
    } catch (e) {
      throw Exception('Repository error: Failed to mark as read - $e');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    try {
      return await _services.markAllAsRead();
    } catch (e) {
      throw Exception('Repository error: Failed to mark all as read - $e');
    }
  }
}
