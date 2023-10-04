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
}
