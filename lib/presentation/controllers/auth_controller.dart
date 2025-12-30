import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';

import '../../core/routes/app_routes.dart';

import '../../data/models/user_model.dart';

import '../../data/services/storage_service.dart';

import '../../domain/usecases/login_usecase.dart';

import '../../domain/usecases/signup_usecase.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final LoginUsecase _loginUsecase;

  final SignupUsecase _signupUsecase;

  AuthController({
    required LoginUsecase loginUsecase,
    required SignupUsecase signupUsecase,
  })  : _loginUsecase = loginUsecase,
        _signupUsecase = signupUsecase;

  // Animation

  late AnimationController animationController;

  late Animation<double> slideAnimation;

  // Form keys

  final loginFormKey = GlobalKey<FormState>();

  final signupFormKey = GlobalKey<FormState>();

  // Text controllers

  final loginEmployeeIdController = TextEditingController();

  final loginPasswordController = TextEditingController();

  final signupNameController = TextEditingController();

  final signupEmployeeIdController = TextEditingController();

  final signupPasswordController = TextEditingController();

  final signupConfirmPasswordController = TextEditingController();

  final signupDepartmentController = TextEditingController();

  // Observable variables

  final isLogin = true.obs;

  final isLoading = false.obs;

  final isPasswordVisible = false.obs;

  final isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    _initializeAnimation();
  }

  void _initializeAnimation() {
    animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    animationController.forward();
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;

    animationController.reset();

    animationController.forward();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final user = await _loginUsecase.call(
        loginEmployeeIdController.text.trim(),
        loginPasswordController.text.trim(),
      );

      // Save user data

      await _saveUserData(user);

      // Navigate to dashboard

      Get.offAllNamed(AppRoutes.dashboard);

      Get.snackbar(
        'Success',
        'Welcome back, ${user.name}!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final user = await _signupUsecase.call(
        name: signupNameController.text.trim(),
        employeeId: signupEmployeeIdController.text.trim(),
        password: signupPasswordController.text.trim(),
        department: signupDepartmentController.text.trim(),
      );

      // Save user data

      await _saveUserData(user);

      // Navigate to dashboard

      Get.offAllNamed(AppRoutes.dashboard);

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    final storageService = Get.find<StorageService>();

    storageService.writeObject(AppConstants.userDataKey, user.toJson());

    storageService.writeString(
        AppConstants.authTokenKey, 'dummy_token_${user.id}');
  }

  @override
  void onClose() {
    animationController.dispose();

    loginEmployeeIdController.dispose();

    loginPasswordController.dispose();

    signupNameController.dispose();

    signupEmployeeIdController.dispose();

    signupPasswordController.dispose();

    signupConfirmPasswordController.dispose();

    signupDepartmentController.dispose();

    super.onClose();
  }
}
