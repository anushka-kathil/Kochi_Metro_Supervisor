class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool read;
  final String severity;
  final DateTime timestamp;
  final String type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.read,
    required this.severity,
    required this.timestamp,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      read: json['read'] as bool,
      severity: json['severity'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'read': read,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    bool? read,
    String? severity,
    DateTime? timestamp,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }
}

class NotificationResponse {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int unreadCount;

  NotificationResponse({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return NotificationResponse(
      notifications: (data['notifications'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList(),
      totalCount: data['total_count'] as int,
      unreadCount: data['unread_count'] as int,
    );
  }
}
