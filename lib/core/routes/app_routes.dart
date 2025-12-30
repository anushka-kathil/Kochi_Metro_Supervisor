// lib/core/routes/app_pages.dart

import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/core/bindings/notification_binding.dart';
import 'package:kochi_metro_supervisor/presentation/pages/notification/notification_page.dart';

import '../../presentation/pages/schedule/train_detail_page.dart';
import '../bindings/auth_binding.dart';

import '../bindings/dashboard_binding.dart';

import '../bindings/maintenance_binding.dart';
import '../bindings/schedule_binding.dart';

import '../../presentation/pages/splash/splash_page.dart';

import '../../presentation/pages/auth/auth_page.dart';

import '../../presentation/pages/dashboard/dashboard_page.dart';

import '../../presentation/pages/schedule/schedule_page.dart';

import '../../presentation/pages/maintenance/maintenance_page.dart';

import 'app_routes.dart';

abstract class AppRoutes {
  static const String splash = '/splash';

  static const String auth = '/auth';

  static const String dashboard = '/dashboard';

  static const String schedule = '/schedule';

  static const String maintenance = '/maintenance';

  static const String notification = '/notification';

  static const String trainDetails = '/trainDetails';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => const SchedulePage(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.maintenance,
      page: () => const MaintenancePage(),
      binding: MaintenanceBinding(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => SchedulePage(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationPage(),
      binding: NotificationBinding(),
    ),
  ];
}
