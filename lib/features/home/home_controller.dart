import 'package:get/get.dart';
import 'package:promptia/api/auth_api.dart';
import 'package:promptia/api/prompt_api.dart';
import 'package:promptia/common/prompt_model.dart';

class HomeController extends GetxController {
  late PromptApi promptApi;
  RxBool isLoading = false.obs;
  RxBool notFound = false.obs;
  RxList<PromptModel> prompts = [PromptModel()].obs;

  @override
  void onInit() {
    AuthApi authApi = AuthApi();
    promptApi = PromptApi(authApi.supabase);
    fetchPropmpts();
    /* listenChanges */ ();

    super.onInit();
  }

  // void listenChanges() async {
  //   authApi.supabase.channel('public:prompts').on(
  //     RealtimeListenTypes.postgresChanges,
  //     ChannelFilter(event: '*', schema: 'public', table: 'prompts'),
  //     (payload, [ref]) {
  //       if (payload["eventType"] == "DELETE") {
  //         var index =
  //             prompts.indexWhere((prompt) => prompt.id == payload["old"]["id"]);
  //         log("The index is $index");
  //         prompts.removeAt(index);
  //         // prompts.remove(PromptModel.fromJson(payload['old']));
  //       } else if (payload["eventType"] == "INSERT") {
  //         PromptModel prompt = PromptModel.fromJson(payload["new"]);
  //         updateFeed(prompt);
  //       }
  //     },
  //   ).subscribe();
  // }

  void fetchPropmpts() async {
    isLoading.value = true;
    List<dynamic> response = await promptApi.fetchPrompts();
    if (response.isNotEmpty) {
      prompts.value = [for (var item in response) PromptModel.fromJson(item)];
      isLoading.value = false;
    } else {
      isLoading.value = false;
      notFound.value = true;
    }
  }


  // * update the prompt-feed on new post
  // void updateFeed(PromptModel prompt) async {
  //   var user = await authApi.getUser(prompt.userId!);
  //   prompt.users = Users.fromJson(user[0]);
  //   prompts.insert(0, prompt);
  //   log("The prompt is ${prompt.toJson()}");
  // }

  @override
  void onClose() async {
    // channel.cancel();

    super.onClose();
  }

  void deletePrompt(PromptModel promptModel) {
    prompts.remove(promptModel);
    promptApi.deletePrompt(promptModel.id!);
  }
}
