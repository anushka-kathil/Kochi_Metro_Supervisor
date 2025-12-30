import 'package:kochi_metro_supervisor/data/services/dashboar_service.dart';
import 'package:kochi_metro_supervisor/data/models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<DashboardOverview> fetchDashboardOverview();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepositoryImpl(this._dashboardService);

  @override
  Future<DashboardOverview> fetchDashboardOverview() async {
    return await _dashboardService.fetchDashboardOverview();
  }
}