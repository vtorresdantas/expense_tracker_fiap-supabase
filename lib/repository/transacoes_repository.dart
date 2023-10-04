import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tipo_transacao.dart';
import '../models/transacao.dart';

class TransacoesReepository {
  Future<List<Transacao>> listarTransacoes(
      {required String userId, TipoTransacao? tipoTransacao}) async {
    final supabase = Supabase.instance.client;

    var query =
        supabase.from('transacoes').select<List<Map<String, dynamic>>>('''
            *,
            categorias (
              *
            ),
            contas (
              *
            )
            ''').eq('user_id', userId);

    if (tipoTransacao != null) {
      query = query.eq('tipo_transacao', tipoTransacao.index);
    }

    var data = await query;

    final list = data.map((map) {
      return Transacao.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarTransacao(Transacao transacao) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transacoes').insert({
      'descricao': transacao.descricao,
      'user_id': transacao.userId,
      'tipo_transacao': transacao.tipoTransacao.index,
      'valor': transacao.valor,
      'data_transacao': transacao.data.toIso8601String(),
      'detalhes': transacao.detalhes,
      'categoria_id': transacao.categoria.id,
      'conta_id': transacao.conta.id,
    });
  }

  Future alterarTransacao(Transacao transacao) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transacoes').update({
      'descricao': transacao.descricao,
      'tipo_transacao': transacao.tipoTransacao.index,
      'valor': transacao.valor,
      'data_transacao': transacao.data.toIso8601String(),
      'detalhes': transacao.detalhes,
      'categoria_id': transacao.categoria.id,
      'conta_id': transacao.conta.id,
    }).match({'id': transacao.id});
  }

  Future excluirTransacao(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transacoes').delete().match({'id': id});
  }
}
