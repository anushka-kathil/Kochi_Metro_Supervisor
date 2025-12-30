import '../../data/models/maintenance_model.dart';
import '../repositories/maintenance_repository.dart';

class MaintenanceUseCase {
  final MaintenanceRepository _repository;

  MaintenanceUseCase(this._repository);

  Future<MaintenanceResponse> execute() async {
    try {
      return await _repository.getMaintenanceData();
    } catch (e) {
      print(e.toString());
      throw Exception('UseCase error: ${e.toString()}');
    }
  }

  List<TrainPriority> sortTrainsByPriority(List<TrainPriority> trains) {
    final sortedTrains = List<TrainPriority>.from(trains);
    sortedTrains.sort((a, b) => a.priorityRank.compareTo(b.priorityRank));
    return sortedTrains;
  }

  List<TrainPriority> filterTrainsByPriorityLevel(
    List<TrainPriority> trains,
    String level,
  ) {
    return trains.where((train) => train.priorityLevel == level).toList();
  }

  List<TrainPriority> searchTrains(List<TrainPriority> trains, String query) {
    if (query.isEmpty) return trains;

    return trains.where((train) {
      return train.trainId.toLowerCase().contains(query.toLowerCase()) ||
          train.priorityLevel.toLowerCase().contains(query.toLowerCase()) ||
          train.priorityRank.toString().contains(query);
    }).toList();
  }
}
