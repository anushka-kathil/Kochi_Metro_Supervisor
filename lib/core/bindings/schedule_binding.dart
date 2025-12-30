import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/data/services/schedule_service.dart';
import 'package:kochi_metro_supervisor/domain/repositories/schedule_repository.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<ScheduleRepository>(
        () => ScheduleRepositoryImpl(ScheduleService()));
  }
}
