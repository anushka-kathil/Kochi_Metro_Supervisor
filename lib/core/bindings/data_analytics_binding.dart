import 'package:get/get.dart';
import '../../presentation/controllers/bottom_nav_controller.dart';

class DataAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
