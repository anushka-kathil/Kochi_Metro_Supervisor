class TrainModel {
  final String id;

  final String number;

  final String status;

  final String currentLocation;

  final bool isOperational;

  final DateTime lastMaintenance;

  TrainModel({
    required this.id,
    required this.number,
    required this.status,
    required this.currentLocation,
    required this.isOperational,
    required this.lastMaintenance,
  });

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      status: json['status'] ?? '',
      currentLocation: json['current_location'] ?? '',
      isOperational: json['is_operational'] ?? false,
      lastMaintenance: DateTime.parse(
          json['last_maintenance'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'status': status,
      'current_location': currentLocation,
      'is_operational': isOperational,
      'last_maintenance': lastMaintenance.toIso8601String(),
    };
  }
}
