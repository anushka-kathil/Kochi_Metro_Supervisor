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
    try {
      final overview = await _dashboardService.fetchDashboardOverview();
      return overview;
    } on Exception catch (e) {
      // Handle known exceptions
      print('Error fetching dashboard overview: $e');
      throw Exception('Failed to fetch dashboard overview');
    } catch (e) {
      // Handle any other errors
      print('Unexpected error: $e');
      throw Exception('Unexpected error occurred');
    }
  }
}