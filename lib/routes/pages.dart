import 'package:get/get.dart';
import 'package:promptia/bindings/auth_binding.dart';
import 'package:promptia/bindings/home_binding.dart';
import 'package:promptia/bindings/profile_binding.dart';
import 'package:promptia/features/auth/screens/signin_screen.dart';
import 'package:promptia/features/auth/screens/signup_screen.dart';
import 'package:promptia/features/home/home_screen.dart';
import 'package:promptia/features/prompt/prompt_screen.dart';
import 'package:promptia/middleware/auth_middleware.dart';
import 'routes.dart';
import 'package:promptia/features/profile/profile_screen.dart';

class Pages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.prompt,
      page: () => PromptScreen(),
      binding: AuthBinding(),
    ),
    // Add more pages as needed
  ];
}
