import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import '../../domain/usecases/notification_usecase.dart';

class NotificationController extends GetxController {
  final NotificationUsecase _usecase;

  NotificationController(this._usecase);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<NotificationResponse?> notificationResponse =
      Rx<NotificationResponse?>(null);
  final RxList<NotificationModel> filteredNotifications =
      <NotificationModel>[].obs;
  final RxString selectedFilter = 'all'.obs;
  final RxString selectedSeverity = 'all'.obs;
  final RxBool showUnreadOnly = false.obs;

  List<NotificationModel> get notifications =>
      notificationResponse.value?.notifications ?? [];
  int get totalCount => notificationResponse.value?.totalCount ?? 0;
  int get unreadCount => notificationResponse.value?.unreadCount ?? 0;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _usecase.getNotifications();
      notificationResponse.value = response;
      _applyFilters();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final success = await _usecase.markAsRead(notificationId);
      if (success) {
        // Update local state
        final updatedNotifications = notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(read: true);
          }
          return notification;
        }).toList();

        // Update the response with new unread count
        final newUnreadCount =
            updatedNotifications.where((n) => !n.read).length;
        notificationResponse.value = NotificationResponse(
          notifications: updatedNotifications,
          totalCount: totalCount,
          unreadCount: newUnreadCount,
        );

        _applyFilters();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark notification as read',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final success = await _usecase.markAllAsRead();
      if (success) {
        // Update local state
        final updatedNotifications = notifications.map((notification) {
          return notification.copyWith(read: true);
        }).toList();

        notificationResponse.value = NotificationResponse(
          notifications: updatedNotifications,
          totalCount: totalCount,
          unreadCount: 0,
        );

        _applyFilters();

        Get.snackbar(
          'Success',
          'All notifications marked as read',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark all notifications as read',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void setSeverityFilter(String severity) {
    selectedSeverity.value = severity;
    _applyFilters();
  }

  void toggleUnreadOnly() {
    showUnreadOnly.value = !showUnreadOnly.value;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<NotificationModel>.from(notifications);

    // Apply type filter
    if (selectedFilter.value != 'all') {
      filtered = _usecase.filterByType(filtered, selectedFilter.value);
    }

    // Apply severity filter
    if (selectedSeverity.value != 'all') {
      filtered = _usecase.filterBySeverity(filtered, selectedSeverity.value);
    }

    // Apply unread filter
    if (showUnreadOnly.value) {
      filtered = _usecase.filterUnread(filtered);
    }

    // Sort by timestamp (newest first)
    filtered = _usecase.sortByTimestamp(filtered, ascending: false);

    filteredNotifications.assignAll(filtered);
  }

  Future<void> refreshNotifications() async {
    await getNotifications();
  }

  Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFE74C3C);
      case 'medium':
        return const Color(0xFFF39C12);
      case 'low':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFF7F8C8D);
    }
  }

  IconData getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'maintenance':
        return Icons.build;
      case 'operational':
        return Icons.info;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }
}
