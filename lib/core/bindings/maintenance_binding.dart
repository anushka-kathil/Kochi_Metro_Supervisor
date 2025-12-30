import 'package:get/get.dart';

import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/services/maintenance_service.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/usecases/maintenance_usecase.dart';
import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/maintenance_controller.dart';

class MaintenanceBinding extends Bindings {
  @override
  void dependencies() {
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
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
