import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/routes.dart';
import '../utils/storage_constants.dart';

class AuthMiddleware extends GetMiddleware {
  final _storage = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final auth = Supabase.instance.client.auth;
    final isLoggedIn = _storage.read(StorageConstants.isLoggedIn) ?? false;

    if (auth.currentSession != null && isLoggedIn) {
      // User is logged in
      if (route == Routes.signIn ||
          route == Routes.signUp ||
          route == Routes.initial) {
        return const RouteSettings(name: Routes.home);
      }
    } else {
      // User is not logged in
      if (route == Routes.home) {
        return const RouteSettings(name: Routes.signIn);
      }
    }
    return null;
  }
}
