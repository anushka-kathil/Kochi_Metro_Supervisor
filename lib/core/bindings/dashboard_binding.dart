import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/data/services/dashboar_service.dart';

import '../../domain/repositories/dashboard_repository.dart';
import '../../presentation/controllers/dashboard_controller.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<DashboardRepository>(
        () => DashboardRepositoryImpl(DashboardService()));

    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
