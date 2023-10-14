import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transferencia.dart';

class TransferenciasRepository {
  Future<List<Transferencia>> listarTransferencias(
      {required String userId, TipoTransferencia? tipoTransferencia}) async {
    final supabase = Supabase.instance.client;

    var query =
        supabase.from('transferencias').select<List<Map<String, dynamic>>>('''
            *,
            usuarios (
              *
            ),
            contas (
              *
            )
            ''').eq('user_id', userId);

    if (tipoTransferencia != null) {
      query = query.eq('tipo_transferencia', tipoTransferencia.index);
    }

    var data = await query;

    final list = data.map((map) {
      return Transferencia.fromMap(map as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<void> cadastrarTransferencia(Transferencia transferencia) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transferencias').insert({
      'descricao': transferencia.descricao,
      'user_id': transferencia.userId,
      'tipo_transferencia': transferencia.tipoTransferencia.index,
      'valor': transferencia.valor,
      'data_transferencia': transferencia.data.toIso8601String(),
      'conta_id': transferencia.conta.id,
      'usuario_id': transferencia.usuario.id,
    });
  }

  Future<void> alterarTransferencia(Transferencia transferencia) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transferencias').update({
      'descricao': transferencia.descricao,
      'valor': transferencia.valor,
      'tipo_transferencia': transferencia.tipoTransferencia.index,
      'data_transferencia': transferencia.data.toIso8601String(),
      'conta_id': transferencia.conta.id,
      'usuario_id': transferencia.usuario.id,
    }).match({'id': transferencia.id});
  }

  Future<void> excluirTransferencia(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transferencias').delete().match({'id': id});
  }
}
