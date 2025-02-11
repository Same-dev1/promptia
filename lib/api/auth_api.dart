import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApi {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(password: password, email: email);
    return response;
  }

  Future<AuthResponse> signUp(
      String name, String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {"name": name},
    );
    return response;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
