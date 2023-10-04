import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/repository/categoria_repository.dart';
import 'package:flutter/material.dart';

import '../models/categoria.dart';

class CategoriesSelectPage extends StatefulWidget {
  final TipoTransacao tipoTransacao;

  const CategoriesSelectPage({super.key, required this.tipoTransacao});

  @override
  State<CategoriesSelectPage> createState() => _CategoriesSelectPageState();
}

class _CategoriesSelectPageState extends State<CategoriesSelectPage> {
  late final Future<List<Categoria>> _futureCategorias;

  @override
  void initState() {
    _futureCategorias = CategoriaRepository()
        .listarCategorias(tipoTransacao: widget.tipoTransacao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Categoria'),
      ),
      body: FutureBuilder(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final categorias = snapshot.data ?? [];
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: categoria.cor,
                    child: Icon(
                      categoria.icone,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(categoria.descricao),
                  onTap: () {
                    Navigator.of(context).pop(categoria);
                  },
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
