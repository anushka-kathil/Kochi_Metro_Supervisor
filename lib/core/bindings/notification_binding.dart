import 'package:get/get.dart';

import '../../data/repositories/notification_repository_impl.dart';
import '../../data/services/notification_service.dart';
import '../../domain/usecases/notification_usecase.dart';
import '../../presentation/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<NotificationServices>(() => NotificationServices());

    // Repository
    Get.lazyPut<NotificationRepositoryImpl>(
      () => NotificationRepositoryImpl(Get.find<NotificationServices>()),
    );

    // Usecase
    Get.lazyPut<NotificationUsecase>(
      () => NotificationUsecase(Get.find<NotificationRepositoryImpl>()),
    );

    // Controller
    Get.lazyPut<NotificationController>(
      () => NotificationController(Get.find<NotificationUsecase>()),
    );
  }
}
