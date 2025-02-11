import 'package:get/get.dart';
import 'package:promptia/features/auth/controllers/auth_controller.dart';
import 'package:promptia/features/auth/controllers/auth_state_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Ensure controllers are registered only once
    Get.lazyPut<AuthStateController>(() => AuthStateController(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
