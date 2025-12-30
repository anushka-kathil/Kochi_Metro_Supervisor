import '../../domain/repositories/maintenance_repository.dart';
import '../models/maintenance_model.dart';
import '../services/maintenance_service.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceService _service;

  MaintenanceRepositoryImpl(this._service);

  @override
  Future<MaintenanceResponse> getMaintenanceData() async {
    try {
      return await _service.fetchMaintenanceData();
    } catch (e) {
      print(e.toString());
      throw Exception('Repository error: ${e.toString()}');
    }
  }
}
