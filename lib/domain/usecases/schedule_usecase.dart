import 'package:kochi_metro_supervisor/data/models/schedule_model.dart';
import 'package:kochi_metro_supervisor/domain/repositories/schedule_repository.dart';

class GetRunningTrainsUseCase {
  final ScheduleRepository repository;

  GetRunningTrainsUseCase(this.repository);

  Future<RunningTrainsResponse> call({
    required String time,
    String? station,
    String? trainId,
  }) {
    return repository.getRunningTrains(
      time: time,
      station: station,
      trainId: trainId,
    );
  }
}

class GenerateScheduleUseCase {
  final ScheduleRepository repository;

  GenerateScheduleUseCase(this.repository);

  Future<GenerateScheduleResponse> call({
    required int availableSlots,
  }) {
    return repository.generateSchedule(
      availableSlots: availableSlots,
    );
  }
}