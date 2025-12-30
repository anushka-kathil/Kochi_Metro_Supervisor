import 'package:get/get.dart';

import '../../data/repositories/auth_repository_impl.dart';

import '../../data/services/api_service.dart';

import '../../domain/repositories/auth_repository.dart';

import '../../domain/usecases/login_usecase.dart';

import '../../domain/usecases/signup_usecase.dart';

import '../../presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Services

    Get.lazyPut<ApiService>(() => ApiService());

    // Repository

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(apiService: Get.find()),
    );

    // Use cases

    Get.lazyPut<LoginUsecase>(() => LoginUsecase(Get.find()));

    Get.lazyPut<SignupUsecase>(() => SignupUsecase(Get.find()));

    // Controller

    Get.lazyPut<AuthController>(
      () => AuthController(
        loginUsecase: Get.find(),
        signupUsecase: Get.find(),
      ),
    );
  }
}
