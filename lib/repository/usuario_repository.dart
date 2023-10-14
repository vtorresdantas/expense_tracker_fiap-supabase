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

  Future<void> cadastrarUsuario(Usuario usuario) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('usuarios').insert({
        'nome': usuario.nome,
        'email': usuario.email,
      });
    } catch (error) {
      print('Erro ao cadastrar usuario: $error');
      rethrow; // Re-lança o erro para ser tratado onde a função é chamada
    }
  }

  Future alterarUsuario(Usuario usuario) async {
    final supabase = Supabase.instance.client;

    await supabase.from('usuarios').update({
      'nome': usuario.nome,
      'email': usuario.email,
    }).match({'user_id': usuario.id});
  }

  Future excluirUsuario(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('usuarios').delete().match({'user_id': id});
  }
}
