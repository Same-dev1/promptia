import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promptia/api/auth_api.dart';
import 'package:promptia/features/auth/controllers/auth_state_controller.dart';

class AuthController extends GetxController {
  late AuthApi authApi;
  final AuthStateController _authStateController =
      Get.find<AuthStateController>();
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController name;
  late final TextEditingController confirmPassword;
  final RxBool isLoading = false.obs;
  final RxBool isSignUpLoading = false.obs;

  @override
  void onInit() {
    authApi = AuthApi();
    email = TextEditingController();
    password = TextEditingController();
    name = TextEditingController();
    confirmPassword = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    if (Get.currentRoute != '/signin') {
      email.dispose();
      password.dispose();
      name.dispose();
      confirmPassword.dispose();
      super.onClose();
    }
  }


  void clearControllers() {
    email.clear();
    password.clear();
    name.clear();
    confirmPassword.clear();
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      final response = await authApi.signIn(email.text, password.text);

      if (response.user != null) {
        clearControllers();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (password.text != confirmPassword.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    try {
      isSignUpLoading.value = true;
      final response = await authApi.signUp(
        name.text,
        email.text,
        password.text,
      );

      if (response.user != null) {
        clearControllers();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isSignUpLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authStateController.signOut();
      clearControllers();
      Get.delete<AuthController>();
      Get.offAllNamed('/sign-in');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? getCurrentUserEmail() {
    return authApi.getCurrentUserEmail();
  }
}
