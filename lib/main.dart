import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'core/theme/app_theme.dart';

import 'core/routes/app_routes.dart';

import 'core/bindings/initial_bindings.dart';

import 'data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service

  await Get.putAsync(() => StorageService().init());
  // Set system UI overlay style

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const KochiMetroApp());
}

class KochiMetroApp extends StatelessWidget {
  const KochiMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kochi Metro Supervisor',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
    );
  }
}
