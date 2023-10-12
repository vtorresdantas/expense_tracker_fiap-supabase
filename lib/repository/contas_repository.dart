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

  Future<void> cadastrarConta(Conta conta) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('contas').insert({
        'descricao': conta.descricao,
        'tipo_conta': conta.tipoConta.index, // Use index do enum
        'banco': conta.bancoId,
      });
    } catch (error) {
      print('Erro ao cadastrar conta: $error');
      throw error; // Re-lança o erro para ser tratado onde a função é chamada
    }
  }

  Future alterarConta(Conta conta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('contas').update({
      'descricao': conta.descricao,
      'tipo_conta': conta.tipoConta.index, // Use index do enum
      'banco': conta.bancoId,
    }).match({'id': conta.id});
  }

  Future excluirConta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('contas').delete().match({'id': id});
  }
}
