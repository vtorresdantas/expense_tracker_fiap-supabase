import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future login(String email, String senha) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signInWithPassword(password: senha, email: email);
  }

  Future registrar(String email, String senha) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signUp(password: senha, email: email);
  }
}
