import 'package:kochi_metro_supervisor/data/models/dashboard_model.dart';
import 'package:kochi_metro_supervisor/domain/repositories/dashboard_repository.dart';

class FetchDashboardOverviewUseCase {
  final DashboardRepository repository;

  FetchDashboardOverviewUseCase(this.repository);

  Future<DashboardOverview> call() async {
    return await repository.fetchDashboardOverview();
  }
}