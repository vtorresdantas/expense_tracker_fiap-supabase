import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/categoria.dart';
import '../models/tipo_transacao.dart';

class CategoriaRepository {
  Future<List<Categoria>> listarCategorias(
      {TipoTransacao? tipoTransacao}) async {
    final supabase = Supabase.instance.client;
    final data =
        await supabase.from('categorias').select<List<Map<String, dynamic>>>();

    final categorias = data
        .map((map) => Categoria.fromMap(map))
        .where((cat) =>
            tipoTransacao == null || cat.tipoTransacao == tipoTransacao)
        .toList();

    return categorias;
  }
}
