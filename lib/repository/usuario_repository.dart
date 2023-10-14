import 'package:expense_tracker/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioRepository {
  Future<List<Usuario>> listarUsuarios() async {
    final supabase = Supabase.instance.client;
    final data =
        await supabase.from('usuarios').select<List<Map<String, dynamic>>>();

    final usuarios = data.map((e) => Usuario.fromMap(e)).toList();

    return usuarios;
  }
}
