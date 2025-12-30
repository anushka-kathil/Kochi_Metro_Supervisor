import '../../data/models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationUsecase {
  final NotificationRepository _repository;

  NotificationUsecase(this._repository);

  Future<NotificationResponse> getNotifications() async {
    try {
      return await _repository.getNotifications();
    } catch (e) {
      throw Exception('Usecase error: $e');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      return await _repository.markAsRead(notificationId);
    } catch (e) {
      throw Exception('Usecase error: $e');
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      return await _repository.markAllAsRead();
    } catch (e) {
      throw Exception('Usecase error: $e');
    }
  }

  List<NotificationModel> filterByType(
      List<NotificationModel> notifications, String? type) {
    if (type == null || type.isEmpty) {
      return notifications;
    }
    return notifications
        .where((notification) => notification.type == type)
        .toList();
  }

  List<NotificationModel> filterBySeverity(
      List<NotificationModel> notifications, String? severity) {
    if (severity == null || severity.isEmpty) {
      return notifications;
    }
    return notifications
        .where((notification) => notification.severity == severity)
        .toList();
  }

  List<NotificationModel> filterUnread(List<NotificationModel> notifications) {
    return notifications.where((notification) => !notification.read).toList();
  }

  List<NotificationModel> sortByTimestamp(List<NotificationModel> notifications,
      {bool ascending = false}) {
    final sortedList = List<NotificationModel>.from(notifications);
    sortedList.sort((a, b) => ascending
        ? a.timestamp.compareTo(b.timestamp)
        : b.timestamp.compareTo(a.timestamp));
    return sortedList;
  }
}
