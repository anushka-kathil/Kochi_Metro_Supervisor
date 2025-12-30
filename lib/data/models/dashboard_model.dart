class DashboardOverview {
  final List<DashboardAlert> alerts;
  final DashboardSummary summary;

  DashboardOverview({required this.alerts, required this.summary});

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      alerts: (json['alerts'] as List)
          .map((e) => DashboardAlert.fromJson(e))
          .toList(),
      summary: DashboardSummary.fromJson(json['summary']),
    );
  }
}

class DashboardAlert {
  final String message;
  final String severity;
  final String timestamp;
  final String type;

  DashboardAlert({
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.type,
  });

  factory DashboardAlert.fromJson(Map<String, dynamic> json) {
    return DashboardAlert(
      message: json['message'],
      severity: json['severity'],
      timestamp: json['timestamp'],
      type: json['type'],
    );
  }
}

class DashboardSummary {
  final int activeTrains;
  final double avgDelayMinutes;
  final int maintenanceTrains;
  final double onTimePercentage;
  final int todayTrips;
  final int totalTrains;

  DashboardSummary({
    required this.activeTrains,
    required this.avgDelayMinutes,
    required this.maintenanceTrains,
    required this.onTimePercentage,
    required this.todayTrips,
    required this.totalTrains,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      activeTrains: json['active_trains'],
      avgDelayMinutes: (json['avg_delay_minutes'] as num).toDouble(),
      maintenanceTrains: json['maintenance_trains'],
      onTimePercentage: (json['on_time_percentage'] as num).toDouble(),
      todayTrips: json['today_trips'],
      totalTrains: json['total_trains'],
    );
  }
}