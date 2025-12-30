import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/domain/usecases/dashboard_usecase.dart';

import '../../data/models/train_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';
import '../../core/constants/app_constants.dart';

// Add these imports
import 'package:kochi_metro_supervisor/data/models/dashboard_model.dart';
import 'package:kochi_metro_supervisor/domain/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final isLoading = false.obs;
  final RxInt availableTrains = 25.obs;
  final RxInt maintenanceTrains = 6.obs;
  final currentUser = Rx<UserModel?>(null);

  // Add observable for dashboard overview
  final dashboardOverview = Rx<DashboardOverview?>(null);

  // Add repository and usecase
  late final DashboardRepository dashboardRepository;
  late final FetchDashboardOverviewUseCase fetchDashboardOverviewUseCase;

  @override
  void onInit() {
    super.onInit();

    _loadUserData();

    // Initialize repository and usecase
    dashboardRepository = Get.find<DashboardRepository>();
    fetchDashboardOverviewUseCase =
        FetchDashboardOverviewUseCase(dashboardRepository);

    fetchDashboardOverview();
  }

  void _loadUserData() {
    final storageService = Get.find<StorageService>();
    final userData = storageService.readObject(AppConstants.userDataKey);
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchDashboardOverview();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Data refreshed successfully',
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  // Implement the usecase here
  Future<void> fetchDashboardOverview() async {
    isLoading.value = true;
    try {
      final overview = await fetchDashboardOverviewUseCase();
      dashboardOverview.value = overview;
      availableTrains.value = overview.summary.activeTrains.toInt();
      maintenanceTrains.value = overview.summary.maintenanceTrains.toInt();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch dashboard overview');
    } finally {
      isLoading.value = false;
    }
  }
}
