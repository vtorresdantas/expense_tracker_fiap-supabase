import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transferencia.dart';

class TransferenciasRepository {
  Future<List<Transferencia>> listarTransferencias(
      {required String userId}) async {
    final supabase = Supabase.instance.client;

    var query =
        supabase.from('Transferencias').select<List<Map<String, dynamic>>>('''
            *,
            contas (
              *
            )
            ''').eq('user_id', userId);

    var data = await query;

    final list = data.map((map) {
      return Transferencia.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarTransferencia(Transferencia Transferencia) async {
    final supabase = Supabase.instance.client;

    await supabase.from('Transferencias').insert({
      'descricao': Transferencia.descricao,
      'user_id': Transferencia.userId,
      'valor': Transferencia.valor,
      'data_Transferencia': Transferencia.data.toIso8601String(),
      'conta_id': Transferencia.conta.id,
    });
  }

  Future alterarTransferencia(Transferencia Transferencia) async {
    final supabase = Supabase.instance.client;

    await supabase.from('Transferencias').update({
      'descricao': Transferencia.descricao,
      'valor': Transferencia.valor,
      'data_Transferencia': Transferencia.data.toIso8601String(),
      'conta_id': Transferencia.conta.id,
    }).match({'id': Transferencia.id});
  }

  Future excluirTransferencia(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('Transferencias').delete().match({'id': id});
  }
}
