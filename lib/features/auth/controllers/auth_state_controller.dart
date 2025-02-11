import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promptia/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/storage_constants.dart';
import 'package:flutter/material.dart';

class AuthStateController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _storage = GetStorage();
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isAuthenticated = false.obs;

  String get initialRoute {
    final session = _supabase.auth.currentSession;
    final storedAuthState = _storage.read(StorageConstants.isLoggedIn) ?? false;
    return (session != null && storedAuthState) ? Routes.home : Routes.signIn;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
    _setupAuthListener();
  }

  void _initializeAuthState() {
    final session = _supabase.auth.currentSession;
    final storedAuthState = _storage.read(StorageConstants.isLoggedIn) ?? false;

    if (session != null && storedAuthState) {
      currentUser.value = session.user;
      isAuthenticated.value = true;

      // Store user data
      _storage.write(StorageConstants.userData, session.user.toJson());
      _storage.write(StorageConstants.authToken, session.accessToken);
      _storage.write(StorageConstants.isLoggedIn, true);
    } else {
      _clearStorageData();
      isAuthenticated.value = false;
    }
  }

  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            currentUser.value = session.user;
            isAuthenticated.value = true;

            // Store session data
            _storage.write(StorageConstants.userData, session.user.toJson());
            _storage.write(StorageConstants.authToken, session.accessToken);
            _storage.write(StorageConstants.isLoggedIn, true);

            Get.offAllNamed(Routes.home);
          }
          break;

        case AuthChangeEvent.signedOut:
          currentUser.value = null;
          isAuthenticated.value = false;
          _clearStorageData();
          Get.offAllNamed(Routes.signIn);
          break;

        case AuthChangeEvent.userUpdated:
          if (session != null) {
            currentUser.value = session.user;
            _storage.write(StorageConstants.userData, session.user.toJson());
          }
          break;

        case AuthChangeEvent.tokenRefreshed:
          if (session != null) {
            _storage.write(StorageConstants.authToken, session.accessToken);
          }
          break;

        default:
          break;
      }
    });
  }

  void _clearStorageData() {
    _storage.remove(StorageConstants.userData);
    _storage.remove(StorageConstants.authToken);
    _storage.remove(StorageConstants.isLoggedIn);
  }

  String? getAuthToken() {
    return _storage.read(StorageConstants.authToken);
  }

  Map<String, dynamic>? getUserData() {
    return _storage.read(StorageConstants.userData);
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _clearStorageData();
      currentUser.value = null;
      isAuthenticated.value = false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      rethrow;
    }
  }
}
