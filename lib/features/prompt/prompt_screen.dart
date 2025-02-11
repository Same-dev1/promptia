import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:promptia/features/prompt/prompt_controller.dart';
import 'package:promptia/features/prompt/prompt_widget.dart';

class PromptScreen extends StatelessWidget {
  PromptScreen({super.key});

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final PromptController controller = Get.put(PromptController());

  void submit() {
    if (_form.currentState!.validate() && controller.isLoading.value == false) {
      controller.store(
          controller.titleController.text, controller.textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add prompt"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: Form(
          key: _form,
          child: Column(
            children: [
              PromptInput(
                controller: controller.titleController,
                hintText: "Type your prompt title",
                validatorCallback:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
              ),
              const SizedBox(
                height: 20,
              ),
              PromptInput(
                controller: controller.textController,
                hintText: "Type your prompt here..",
                validatorCallback:
                    ValidationBuilder().minLength(10).maxLength(500).build(),
                isPromptField: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        controller.isLoading.value ? "Loading.." : "Submit",
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
