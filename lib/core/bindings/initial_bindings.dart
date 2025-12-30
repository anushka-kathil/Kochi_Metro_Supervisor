import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/services/maintenance_service.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/usecases/maintenance_usecase.dart';
import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/maintenance_controller.dart';

import 'package:kochi_metro_supervisor/data/services/schedule_service.dart';
import 'package:kochi_metro_supervisor/domain/repositories/schedule_repository.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';

import 'package:kochi_metro_supervisor/data/services/dashboar_service.dart';

import '../../domain/repositories/dashboard_repository.dart';
import '../../presentation/controllers/dashboard_controller.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);

    // Service
    Get.lazyPut<MaintenanceService>(() => MaintenanceService());

    // Repository
    Get.lazyPut<MaintenanceRepository>(
      () => MaintenanceRepositoryImpl(Get.find<MaintenanceService>()),
    );

    // Use Casex
    Get.lazyPut<MaintenanceUseCase>(
      () => MaintenanceUseCase(Get.find<MaintenanceRepository>()),
    );

    // Controller
    Get.lazyPut<MaintenanceController>(
      () => MaintenanceController(Get.find<MaintenanceUseCase>()),
    );

    Get.lazyPut<ScheduleController>(() => ScheduleController());

    Get.lazyPut<ScheduleRepository>(
        () => ScheduleRepositoryImpl(ScheduleService()));

    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<DashboardRepository>(
        () => DashboardRepositoryImpl(DashboardService()));
  }
}
