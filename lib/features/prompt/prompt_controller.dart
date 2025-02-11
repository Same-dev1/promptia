import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promptia/api/auth_api.dart';
import 'package:promptia/api/prompt_api.dart';
import 'package:promptia/routes/routes.dart';

class PromptController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  RxBool isLoading = false.obs;
  late final PromptApi promptApi;

  @override
  void onInit() {
    super.onInit();
    promptApi = PromptApi(AuthApi().supabase);
  }

  // * to create new prompt
  void store(String title, String prompt) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "title": title,
        "prompt": prompt,
        "user_id": AuthApi().supabase.auth.currentUser?.id,
      };
      await promptApi.store(body);
      Get.offNamed(Routes.home); // Navigate to home after storing
    } catch (e) {
      log("The error is $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
