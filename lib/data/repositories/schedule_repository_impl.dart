import 'package:kochi_metro_supervisor/data/models/schedule_model.dart';
import 'package:kochi_metro_supervisor/data/services/schedule_service.dart';

class ScheduleException implements Exception {
  final String message;
  ScheduleException(this.message);

  @override
  String toString() => 'ScheduleException: $message';
}

abstract class ScheduleRepository {
  Future<RunningTrainsResponse> getRunningTrains({
    required String time,
    String? station,
    String? trainId,
  });

  Future<GenerateScheduleResponse> generateSchedule({
    required int availableSlots,
  });
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleService _service;

  ScheduleRepositoryImpl(this._service);

  @override
  Future<RunningTrainsResponse> getRunningTrains({
    required String time,
    String? station,
    String? trainId,
  }) async {
    try {
      return await _service.getRunningTrains(
        time: time,
        station: station,
        trainId: trainId,
      );
    } on ScheduleException catch (e) {
      // Custom error handling for known exceptions
      throw ScheduleException('Failed to fetch running trains: ${e.message}');
    } catch (e) {
      // Handle unknown errors
      throw ScheduleException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<GenerateScheduleResponse> generateSchedule({
    required int availableSlots,
  }) async {
    try {
      return await _service.generateSchedule(
        availableSlots: availableSlots,
      );
    } on ScheduleException catch (e) {
      throw ScheduleException('Failed to generate schedule: ${e.message}');
    } catch (e) {
      throw ScheduleException('An unexpected error occurred: $e');
    }
  }
}