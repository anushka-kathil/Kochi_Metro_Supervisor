import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  final List<String> routes = [
    AppRoutes.dashboard,
    AppRoutes.schedule,
    AppRoutes.maintenance,
  ];

  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;

      Get.offAllNamed(routes[index]);
    }
  }
}
