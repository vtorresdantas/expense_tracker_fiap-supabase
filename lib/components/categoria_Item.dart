import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:flutter/material.dart';

import '../models/categoria.dart';

class CategoriaItem extends StatelessWidget {
  final Categoria categoria;
  const CategoriaItem({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: categoria.cor,
        child: Icon(
          categoria.icone,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(
        categoria.descricao,
      ),
      trailing: Text(
        categoria.tipoTransacao == TipoTransacao.despesa
            ? 'Despesa'
            : 'Receita',
        style: TextStyle(
          fontSize: 14,
          color: categoria.tipoTransacao == TipoTransacao.despesa
              ? Colors.pink
              : Colors.green,
        ),
      ),
    );
  }
}
