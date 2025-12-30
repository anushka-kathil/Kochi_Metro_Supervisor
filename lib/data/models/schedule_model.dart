// Models

class RunningTrainsResponse {
  final RunningTrainsData? data;
  final String status;
  final DateTime? timestamp;
  final String? error;

  RunningTrainsResponse({
    this.data,
    required this.status,
    this.timestamp,
    this.error,
  });

  factory RunningTrainsResponse.fromJson(Map<String, dynamic> json) {
    return RunningTrainsResponse(
      data: json['data'] != null ? RunningTrainsData.fromJson(json['data']) : null,
      status: json['status'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      error: json['error'],
    );
  }
}

class RunningTrainsData {
  final String queryTime;
  final List<RunningTrain> runningTrains;
  final String? stationFilter;
  final int totalRunningTrains;
  final String? trainIdFilter;

  RunningTrainsData({
    required this.queryTime,
    required this.runningTrains,
    this.stationFilter,
    required this.totalRunningTrains,
    this.trainIdFilter,
  });

  factory RunningTrainsData.fromJson(Map<String, dynamic> json) {
    return RunningTrainsData(
      queryTime: json['query_time'] ?? '',
      runningTrains: (json['running_trains'] as List<dynamic>? ?? [])
          .map((e) => RunningTrain.fromJson(e))
          .toList(),
      stationFilter: json['station_filter'],
      totalRunningTrains: json['total_running_trains'] ?? 0,
      trainIdFilter: json['train_id_filter'],
    );
  }
}

class RunningTrain {
  final String currentLocation;
  final CurrentTrip currentTrip;
  final PriorityInfo priorityInfo;
  final String stationStatus;
  final String status;
  final String trainId;
  final TripDetails tripDetails;
  final String tripId;
  final String tripStatus;

  RunningTrain({
    required this.currentLocation,
    required this.currentTrip,
    required this.priorityInfo,
    required this.stationStatus,
    required this.status,
    required this.trainId,
    required this.tripDetails,
    required this.tripId,
    required this.tripStatus,
  });

  factory RunningTrain.fromJson(Map<String, dynamic> json) {
    return RunningTrain(
      currentLocation: json['current_location'] ?? '',
      currentTrip: json['current_trip'] != null
          ? CurrentTrip.fromJson(json['current_trip'])
          : CurrentTrip(
              endStation: '',
              endTime: '',
              progressPercentage: 0.0,
              startStation: '',
              startTime: '',
            ),
      priorityInfo: json['priority_info'] != null
          ? PriorityInfo.fromJson(json['priority_info'])
          : PriorityInfo(priorityRank: 0, priorityScore: 0.0),
      stationStatus: json['station_status'] ?? '',
      status: json['status'] ?? '',
      trainId: json['train_id'] ?? '',
      tripDetails: json['trip_details'] != null
          ? TripDetails.fromJson(json['trip_details'])
          : TripDetails(
              currentPosition: 0,
              stationPosition: 0,
              stops: [],
              totalStops: 0,
            ),
      tripId: json['trip_id'] ?? '',
      tripStatus: json['trip_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_location': currentLocation,
      'current_trip': currentTrip.toJson(),
      'priority_info': priorityInfo.toJson(),
      'station_status': stationStatus,
      'status': status,
      'train_id': trainId,
      'trip_details': tripDetails.toJson(),
      'trip_id': tripId,
      'trip_status': tripStatus,
    };
  }
}

class CurrentTrip {
  final String endStation;
  final String endTime;
  final double progressPercentage;
  final String startStation;
  final String startTime;

  CurrentTrip({
    required this.endStation,
    required this.endTime,
    required this.progressPercentage,
    required this.startStation,
    required this.startTime,
  });

  factory CurrentTrip.fromJson(Map<String, dynamic> json) {
    return CurrentTrip(
      endStation: json['end_station'] ?? '',
      endTime: json['end_time'] ?? '',
      progressPercentage: (json['progress_percentage'] ?? 0).toDouble(),
      startStation: json['start_station'] ?? '',
      startTime: json['start_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'end_station': endStation,
      'end_time': endTime,
      'progress_percentage': progressPercentage,
      'start_station': startStation,
      'start_time': startTime,
    };
  }
}

class PriorityInfo {
  final int priorityRank;
  final double priorityScore;

  PriorityInfo({
    required this.priorityRank,
    required this.priorityScore,
  });

  factory PriorityInfo.fromJson(Map<String, dynamic> json) {
    return PriorityInfo(
      priorityRank: json['priority_rank'] ?? 0,
      priorityScore: (json['priority_score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priority_rank': priorityRank,
      'priority_score': priorityScore,
    };
  }
}

class TripDetails {
  final int currentPosition;
  final int stationPosition;
  final List<Stop> stops;
  final int totalStops;

  TripDetails({
    required this.currentPosition,
    required this.stationPosition,
    required this.stops,
    required this.totalStops,
  });

  factory TripDetails.fromJson(Map<String, dynamic> json) {
    return TripDetails(
      currentPosition: json['current_position'] ?? 0,
      stationPosition: json['station_position'] ?? 0,
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => Stop.fromJson(e))
          .toList(),
      totalStops: json['total_stops'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_position': currentPosition,
      'station_position': stationPosition,
      'stops': stops.map((e) => e.toJson()).toList(),
      'total_stops': totalStops,
    };
  }
}

class Stop {
  final String arrivalTime;
  final String departureTime;
  final String stopId;
  final String stopName;

  Stop({
    required this.arrivalTime,
    required this.departureTime,
    required this.stopId,
    required this.stopName,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      arrivalTime: json['arrival_time'] ?? '',
      departureTime: json['departure_time'] ?? '',
      stopId: json['stop_id'] ?? '',
      stopName: json['stop_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arrival_time': arrivalTime,
      'departure_time': departureTime,
      'stop_id': stopId,
      'stop_name': stopName,
    };
  }
}



class GenerateScheduleRequest {
  final int availableSlots;

  GenerateScheduleRequest({required this.availableSlots});

  Map<String, dynamic> toJson() => {
        'available_slots': availableSlots,
      };
}

class GenerateScheduleResponse {
  final GenerateScheduleData? data;
  final String message;
  final String status;

  GenerateScheduleResponse({
    this.data,
    required this.message,
    required this.status,
  });

  factory GenerateScheduleResponse.fromJson(Map<String, dynamic> json) {
    return GenerateScheduleResponse(
      data: json['data'] != null
          ? GenerateScheduleData.fromJson(json['data'])
          : null,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class GenerateScheduleData {
  final int availableSlots;
  final List<String> maintenanceTrains;
  final GenerateScheduleMetadata metadata;
  final Map<String, List<String>> schedule;
  final String selectedCriteria;
  final GenerateScheduleValidation validation;

  GenerateScheduleData({
    required this.availableSlots,
    required this.maintenanceTrains,
    required this.metadata,
    required this.schedule,
    required this.selectedCriteria,
    required this.validation,
  });

  factory GenerateScheduleData.fromJson(Map<String, dynamic> json) {
    return GenerateScheduleData(
      availableSlots: json['available_slots'] ?? 0,
      maintenanceTrains: (json['maintenance_trains'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      metadata: GenerateScheduleMetadata.fromJson(json['metadata'] ?? {}),
      schedule: (json['schedule'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(
              k, (v as List<dynamic>).map((e) => e.toString()).toList())),
      selectedCriteria: json['selected_criteria'] ?? '',
      validation: GenerateScheduleValidation.fromJson(json['validation'] ?? {}),
    );
  }
}

class GenerateScheduleMetadata {
  final int availableSlotsRequested;
  final int maintenanceSlotsUsed;

  GenerateScheduleMetadata({
    required this.availableSlotsRequested,
    required this.maintenanceSlotsUsed,
  });

  factory GenerateScheduleMetadata.fromJson(Map<String, dynamic> json) {
    return GenerateScheduleMetadata(
      availableSlotsRequested: json['available_slots_requested'] ?? 0,
      maintenanceSlotsUsed: json['maintenance_slots_used'] ?? 0,
    );
  }
}

class GenerateScheduleValidation {
  final bool isValid;
  final GenerateScheduleValidationReport report;

  GenerateScheduleValidation({
    required this.isValid,
    required this.report,
  });

  factory GenerateScheduleValidation.fromJson(Map<String, dynamic> json) {
    return GenerateScheduleValidation(
      isValid: json['is_valid'] ?? false,
      report: GenerateScheduleValidationReport.fromJson(json['report'] ?? {}),
    );
  }
}

class GenerateScheduleValidationReport {
  final double overallAccuracy;

  GenerateScheduleValidationReport({required this.overallAccuracy});

  factory GenerateScheduleValidationReport.fromJson(Map<String, dynamic> json) {
    return GenerateScheduleValidationReport(
      overallAccuracy: (json['overall_accuracy'] ?? 0).toDouble(),
    );
  }
}