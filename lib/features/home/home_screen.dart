import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:promptia/common/prompt_card.dart';
import 'package:promptia/features/home/home_controller.dart';
import 'package:promptia/routes/routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.prompt),
        backgroundColor: Colors.black,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Add Prompt',
          style: GoogleFonts.specialElite(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHero(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Latest Prompts",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(() => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.prompts.isNotEmpty && !controller.notFound.value
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.fetchPropmpts();
                          },
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: controller.prompts.length,
                              itemBuilder: (context, index) => PromptCard(
                                    promptModel: controller.prompts[index],
                                  )),
                        ),
                      )
                    : const NoPromptFound())
          ],
        ),
      ),
    );
  }
}

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Promptia",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.profile),
              child: const Text('Profile'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "The app that makes your chat AI more creative, more engaging, and more fun.",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class NoPromptFound extends StatelessWidget {
  const NoPromptFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("No Prompt found ."),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => Get.offAndToNamed(Routes.prompt),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Create new prompt"),
        )
      ],
    );
  }
}
