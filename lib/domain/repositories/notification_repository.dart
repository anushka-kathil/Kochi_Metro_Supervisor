import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationResponse> getNotifications();
  Future<bool> markAsRead(String notificationId);
  Future<bool> markAllAsRead();
}
