import 'package:get/get.dart';
import 'package:promptia/features/auth/controllers/auth_controller.dart';
import 'package:promptia/features/profile/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
