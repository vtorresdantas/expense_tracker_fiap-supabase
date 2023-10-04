import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conta.dart';

class ContasRepository {
  Future<List<Conta>> listarContas() async {
    final supabase = Supabase.instance.client;
    final data =
        await supabase.from('contas').select<List<Map<String, dynamic>>>();

    final contas = data.map((e) => Conta.fromMap(e)).toList();

    return contas;
  }

  Future cadastrarConta(Conta conta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('contas').insert({
      'banco': conta.bancoId,
      'descricao': conta.descricao,
      'tipo_Conta': conta.tipoConta,
    });
  }

  Future alterarConta(Conta conta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('contas').update({
      'banco': conta.bancoId,
      'descricao': conta.descricao,
      'tipo_Conta': conta.tipoConta,
    }).match({'id': conta.id});
  }

  Future excluirConta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('contas').delete().match({'id': id});
  }
}
