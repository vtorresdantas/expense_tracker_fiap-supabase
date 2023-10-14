import 'package:expense_tracker/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UsuarioSelect extends StatelessWidget {
  final Usuario? usuario;
  final void Function()? onTap;

  const UsuarioSelect({super.key, this.usuario, this.onTap});

  @override
  Widget build(BuildContext context) {
    final circleAvatar = usuario == null
        ? CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: const Icon(
              Ionicons.person_add_outline,
              color: Colors.white,
            ),
          )
        : CircleAvatar();

    return ListTile(
      title: Text(usuario?.nome ?? 'Selecione um usuário'),
      leading: circleAvatar, // Usé leading en lugar de CircleAvatar
      trailing: const Icon(Ionicons.chevron_forward_outline),
      onTap: onTap,
    );
  }
}
