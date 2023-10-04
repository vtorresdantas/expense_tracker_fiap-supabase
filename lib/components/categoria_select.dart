import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../models/categoria.dart';

class CategoriaSelect extends StatelessWidget {
  final Categoria? categoria;
  final void Function()? onTap;
  const CategoriaSelect({super.key, this.categoria, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: categoria?.cor ?? Colors.grey.shade400,
        child: Icon(
          categoria?.icone ?? Ionicons.list_outline,
          color: Colors.white,
        ),
      ),
      title: Text(categoria?.descricao ?? 'Selecione uma categoria'),
      trailing: const Icon(Ionicons.chevron_forward_outline),
      onTap: onTap,
    );
  }
}
