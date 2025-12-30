import 'package:kochi_metro_supervisor/data/models/schedule_model.dart';
import 'package:kochi_metro_supervisor/data/services/schedule_service.dart';

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
  }) {
    return _service.getRunningTrains(
      time: time,
      station: station,
      trainId: trainId,
    );
  }

  @override
  Future<GenerateScheduleResponse> generateSchedule({
    required int availableSlots,
  }) {
    return _service.generateSchedule(
      availableSlots: availableSlots,
    );
  }
}