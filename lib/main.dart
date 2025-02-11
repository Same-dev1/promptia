import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:promptia/features/auth/controllers/auth_state_controller.dart';
import 'package:promptia/routes/pages.dart';
import 'package:promptia/utils/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Supabase.initialize(
    url: appUrl,
    anonKey: anonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authStateController = Get.put(AuthStateController(), permanent: true);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Promptia',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.black),
        textTheme: GoogleFonts.specialEliteTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      initialRoute: authStateController.initialRoute,
      getPages: Pages.pages,
    );
  }
}
