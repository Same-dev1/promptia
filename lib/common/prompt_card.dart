import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:promptia/common/prompt_model.dart';
import 'package:promptia/features/home/home_controller.dart';

class PromptCard extends StatelessWidget {
  final PromptModel promptModel;

  const PromptCard({
    super.key,
    required this.promptModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onLongPress: () {
              Get.defaultDialog(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                title: "Delete Prompt",
                middleText: "Are you sure you want to delete this prompt?",
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.find<HomeController>().deletePrompt(promptModel);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
            title: Text(promptModel.users!.metadata!.name!),
            subtitle: Text(formatDateTime(promptModel.createdAt!)),
            trailing: IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: promptModel.prompt!));
                  Get.snackbar(
                    "Wooo",
                    "prompt copied !!",
                  );
                },
                icon: const Icon(Icons.copy)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promptModel.title!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(promptModel.prompt!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat('dd MMM yyyy');
  String formattedDate = formatter.format(dateTime);
  return formattedDate;
}
