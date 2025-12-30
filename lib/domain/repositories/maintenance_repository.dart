import '../../data/models/maintenance_model.dart';

abstract class MaintenanceRepository {
  Future<MaintenanceResponse> getMaintenanceData();
}
