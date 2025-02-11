import 'dart:developer';
import 'package:get/get.dart';
import 'package:promptia/api/auth_api.dart';
import 'package:promptia/api/prompt_api.dart';
import 'package:promptia/common/prompt_model.dart';
import 'package:promptia/features/auth/controllers/auth_controller.dart';
import '../auth/controllers/auth_state_controller.dart';

class ProfileController extends GetxController {
  final authController = Get.find<AuthController>();
  final authStateController = Get.find<AuthStateController>();

  late PromptApi promptApi;
  RxBool isLoading = false.obs;
  RxBool notFound = false.obs;
  RxList<PromptModel> prompts = [PromptModel()].obs;

  @override
  void onInit() {
    AuthApi authApi = AuthApi();
    promptApi = PromptApi(authApi.supabase);
    fetchPropmpts();
    super.onInit();
  }

  void fetchPropmpts() async {
    isLoading.value = true;
    List<dynamic> response = await promptApi.fetchUserPrompts();
    if (response.isNotEmpty) {
      prompts.value = [for (var item in response) PromptModel.fromJson(item)];
      isLoading.value = false;
    } else {
      isLoading.value = false;
      notFound.value = true;
    }
  }

  void deletePrompt(PromptModel promptModel) async {
    try {
      prompts.remove(promptModel);
      await promptApi.deletePrompt(promptModel.id!);
      Get.snackbar("Success", "Prompt Deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
      log("The error is $e");
    }
  }

}